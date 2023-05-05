contract NFTLoan {
    address public owner;
     struct NftLoasInfo {
        uint256 tokenId;
        uint256 loanAmount;
        uint256 loanDeadLine;            
    }
    require(nftContract.getApproved(_tokenId) == address(this), "Contract is not approved to manage this NFT");
    require(nftContract.isApprovedForAll(msg.sender, address(this)), "You need to approve contract to manage your NFTs");
    uint256 interestRate;
    IERC721 public nftContract;
    mapping (address => NftLoasInfo) public loans;
    
constructor(address _owner,uint256 _interestRate,address _nftContract) {
    owner = _owner;
    interestRate =  _interestRate;
    nftContract = IERC721(_nftContract);
}
function depositNFT(uint256 _tokenId,uint256 _loanAmount,uint256 _loanDeadLine;) public {
    require(nftContract.ownerOf(_tokenId) == msg.sender, "You don't own this NFT");
    loans[msg.sender].tokenId = _tokenId;
    loans[msg.sender].loanAmount = _loanAmount;
    loans[msg.sender].loanDeadLine = _loanDeadLine;
    nftContract.transferFrom(msg.sender, address(this), _tokenId);
}
function withdrawNFT() public {
    require(loans[msg.sender].loanAmount != 0, "You don't have any NFT deposited");
    tokenId = loans[msg.sender].tokenId
    nftContract = IERC721(_nftContract);
    loans[msg.sender].tokenId  = 0;
    loans[msg.sender].loanAmount  = 0;
    loans[msg.sender].loanDeadLine  = 0;
    nftContract.transferFrom(address(this), msg.sender, tokenId);
}

}

