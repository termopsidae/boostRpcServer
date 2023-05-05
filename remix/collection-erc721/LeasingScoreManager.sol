pragma solidity ^0.4.20;
contract LeasingScoreManager {
    identity[] adminList;
    identity[] observerList;
    identity[] calculatorList;
    //用于记录管理数组被置位元素
    uint adminDeled;
    uint observerDeled;
    uint calculatorDeled;
    mapping (bytes32 => uint) leasingScore;
    enum ScoreAction {
        //奖励积分， 因相关行为，进行积分奖励
        ActionAwardScore,
        //积分权益兑换，花费指定积分
        ActionExchangeScore,
        //扣除积分， 因违规等， 扣除积分
        ActionDeductScore,
        //查询积分
        ActionQueryScore
        //积分转移, 将积分转移到其他的合约。
    }
    enum UserRole {
        RoleAdmin, //管理员
        RoleCalculator, //积分操作员
        RoleObserver, //积分查看人员
        RolePlayer //积分参与者
    }
    //是否为有效的操作人
    event VALID(bool valid, UserRole role);
    //admin/observer/calculator 用户存在
    event USER_EXIST(bool exist, UserRole role);
    //积分事件
    event SCORE_OPERATOR(ScoreAction action, string describe);
    //积分操作错误
    event SCORE_ERROR(ScoreAction action, string describe);
    //积分权益通知
    event SCORE_EQUITY_NOTICE(string action, uint score, string describe);
    constructor() public {
        adminList.push(msg.sender);
        adminList.push(this);
    }
    function indexAdmin(identity admin) view returns (uint) {
        for (uint i = 0; i < adminList.length; i++) {
            if (adminList[i] == admin) {
                return i;
            }
        }
        return adminList.length;
    }
    function validAdmin(identity admin) view returns (bool) {
        return indexAdmin(admin) < adminList.length;
    }
    function indexCalculator(identity calculator) view returns (uint) {
        for (uint i = 0; i < calculatorList.length; i++) {
            if (calculatorList[i] == calculator) {
                return i;
            }
        }
        return calculatorList.length;
    }
    function validCalculator(identity calculator) view returns (bool) {
        return indexCalculator(calculator) < calculatorList.length;
    }
    function indexObserver(identity observer) view returns (uint) {
        for (uint i = 0; i < observerList.length; i++) {
            if (observerList[i] == observer) {
                return i;
            }
        }
        return observerList.length;
    }
    function validObserver(identity observer) view returns (bool) {
        return indexObserver(observer) < observerList.length;
    }
    modifier onlyAdmin {
        bool isValid = validAdmin(msg.sender);
        emit VALID(isValid, UserRole.RoleAdmin);
        require(isValid);
        _;
    }
    modifier onlyCalculatorOrAdmin {
        bool isValid = validAdmin(msg.sender);
        if(isValid) {
            emit VALID(isValid, UserRole.RoleAdmin);
        } else {
            isValid = validCalculator(msg.sender);
            emit VALID(isValid, UserRole.RoleCalculator);
        }
        require(isValid);
        _;
    }
    modifier onlyObserverOrAdmin {
        bool isValid = validAdmin(msg.sender);
        if(isValid) {
            emit VALID(isValid, UserRole.RoleAdmin);
        } else {
            isValid = validObserver(msg.sender);
            emit VALID(isValid, UserRole.RoleObserver);
        }
        require(isValid);
        _;
    }
    function addAdmin(identity admin) public onlyAdmin {
        bool isExist = validAdmin(admin);
        emit USER_EXIST(isExist, UserRole.RoleAdmin);
        require(!isExist);
        if(adminDeled > 0) {
            uint deled = 1;
            for (uint i = 0; i < adminList.length; i++) {
                if(deled&adminDeled != 0) {
                    adminList[i] = admin;
                    adminDeled ^= deled;
                    break;
                }
                deled <<= 1;
            }
        } else {
            adminList.push(admin);
        }
    }
    function removeAdmin(identity admin) public onlyAdmin {
        uint index = indexAdmin(admin);
        bool isValid = index != adminList.length;
        emit USER_EXIST(isValid, UserRole.RoleAdmin);
        require(isValid);
        delete adminList[index];
        adminDeled ^= 1 << index;
    }
    function queryAdmins() view public onlyAdmin returns (identity[]) {
        return adminList;
    }
    function addCalculator(identity calculator) public onlyAdmin {
        bool isExist = validCalculator(calculator);
        emit USER_EXIST(isExist, UserRole.RoleCalculator);
        require(!isExist);
        if(calculatorDeled > 0) {
            uint deled = 1;
            for (uint i = 0; i < calculatorList.length; i++) {
                if(deled&calculatorDeled != 0) {
                    calculatorList[i] = calculator;
                    calculatorDeled ^= deled;
                    break;
                }
                deled <<= 1;
            }
        } else {
            calculatorList.push(calculator);
        }
    }
    function removeCalculator(identity calculator) public onlyAdmin {
        uint index = indexCalculator(calculator);
        bool isValid = index < calculatorList.length;
        emit USER_EXIST(isValid, UserRole.RoleCalculator);
        require(isValid);
        delete calculatorList[index];
        calculatorDeled ^= 1 << index;
    }
    function queryCalculators() view public onlyCalculatorOrAdmin returns (identity[]) {
        return calculatorList;
    }
    function addObserver(identity observer) public onlyAdmin {
        bool isExist = validObserver(observer);
        emit USER_EXIST(isExist, UserRole.RoleObserver);
        require(!isExist);
        if(observerDeled > 0) {
            uint deled = 1;
            for (uint i = 0; i < observerList.length; i++) {
                if(deled&observerDeled != 0) {
                    observerList[i] = observer;
                    observerDeled ^= deled;
                    break;
                }
                deled <<= 1;
            }
        } else {
            observerList.push(observer);
        }
    }
    function removeObserver(identity observer) public onlyAdmin {
        uint index = indexCalculator(observer);
        bool isValid = index < observerList.length;
        emit USER_EXIST(isValid, UserRole.RoleObserver);
        require(isValid);
        delete observerList[index];
        observerDeled ^= 1 << index;
    }
    function queryObservers() view public onlyObserverOrAdmin returns (identity[]) {
        return observerList;
    }
    function checkScoreEquity(uint balance, uint score) {
        uint total = balance + score;
        if(total >= 100 && balance < 100) {
            emit SCORE_EQUITY_NOTICE("RentConcessions", total, "Citizens enjoy a 90% discount on rental housing");
        }
        if(total >= 200 && balance < 200) {
            emit SCORE_EQUITY_NOTICE("RentConcessions_1", total, "Citizens enjoy a 80% discount on rental housing");
        }
        if(total >= 300 && balance < 300) {
            emit SCORE_EQUITY_NOTICE("PurchaseDiscount", total, "Citizens enjoy a 90% discount on purchase housing");
        }
    }
    //积分奖励
    function awardScore(bytes32 player, uint score, string describe) public onlyCalculatorOrAdmin {
        uint balance = leasingScore[player];
        leasingScore[player] = balance + score;
        emit SCORE_OPERATOR(ScoreAction.ActionAwardScore, describe);
        checkScoreEquity(balance, score);
    }
    //积分权级兑换，为消费者主动意愿，若不够花，则不扣除积分，且发送失败事件。
    function exchangeScore(bytes32 player, uint score, string describe) public onlyCalculatorOrAdmin returns (bool) {
        emit SCORE_OPERATOR(ScoreAction.ActionExchangeScore, describe);
        if(leasingScore[player] >= score) {
            leasingScore[player] -= score;
            return true;
        }
        emit SCORE_ERROR(ScoreAction.ActionExchangeScore, "Score not enough to exchange");
        return false;
    }
    //积分扣除，为消费者被动意愿，进行强制积分扣除，若积分不够，则清零，且发送失败时间
    function deductScore(bytes32 player, uint score, string describe) public onlyCalculatorOrAdmin {
        emit SCORE_OPERATOR(ScoreAction.ActionDeductScore, describe);
        uint balance = leasingScore[player];
        if(balance >= score) {
            leasingScore[player] -= score;
        } else {
            if(balance != 0) {
                leasingScore[player] = 0;
            }
            emit SCORE_ERROR(ScoreAction.ActionDeductScore, "Score not enough to deduct");
        }
    }
    //积分查询
    function queryScore(bytes32 player, string describe) view public onlyObserverOrAdmin returns (uint) {
        emit SCORE_OPERATOR(ScoreAction.ActionQueryScore, describe);
        return leasingScore[player];
    }
    //拼接字符串
    function stringAdd(string a, string b) returns(string){
        bytes memory _a = bytes(a);
        bytes memory _b = bytes(b);
        bytes memory res = new bytes(_a.length + _b.length);
        for(uint i = 0;i < _a.length;i++)
            res[i] = _a[i];
        for(uint j = 0;j < _b.length;j++)
            res[_a.length+j] = _b[j];
        return string(res);
    }
    //积分转移，将积分从一个一个合约转移到另一个合约
    function transferScore(bytes32 player, uint score, LeasingScoreManager toContract, string describe) public onlyCalculatorOrAdmin {
        //判断积分是否够用并扣除
        describe =  stringAdd("Transfer score: ", describe);
        require(exchangeScore(player, score, describe));
        toContract.awardScore(player, score, describe);
    }
}