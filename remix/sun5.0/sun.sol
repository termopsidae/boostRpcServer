// Copyright 2021 The Hillstone Patners 
// and EntySquare Software Studio
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./safemath.sol";
contract SUN {
    //participant's struct 
   struct Participant{
        string name;
        address pAddress;
        address rAddress;
        Pandora[] Pandoras;
    }
    struct Pandora{
        uint8 id;
        address owner;
        uint256 power;
        uint256 tOn;
        uint8  state; //0.tOn 1.ready 2.closed 
    }
    struct PowerReserve{
        uint256 AllPower; //100%
        uint256 StoragePower; //65%
        uint256 StaticPower; //26%
        uint256 FlowPower; //6%
        uint256 AspiratedPower; //1%
        uint256 SalvationalPower; //2%
    }
    using SafeMath for uint256;
    address manager;
    PowerReserve public pr;
    uint256 AccumulatePower;
    constructor(
        address holder)  public {
        manager = holder;
        pr.AllPower = 0 ;
        pr.StoragePower = 0 ;
        pr.StaticPower = 0 ;
        pr.FlowPower = 0 ;
        pr.AspiratedPower = 0 ;
        pr.SalvationalPower = 0 ;
        // nextWDLPoolAmount = 0;
        // nextScorePoolAmount = 0;
    }
    function restartReserve() internal returns (bool) {
        
    }
    function Aspirated(address toAddress,uint256 amount)external onlyManager payable returns(bool){
            address payable toAddress_address = payable(toAddress);
            toAddress_address.transfer(amount);
            return true;
    }

    receive() external payable {
         
   }
    // @notice only manager can do in this condition
    modifier onlyManager() { 
        require(
            msg.sender == manager,
            "Only owner can call this."
        );
        _;
    }
}