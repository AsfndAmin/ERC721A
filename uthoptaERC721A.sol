// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";


contract Uthopia721 is ERC721A, Pausable, Ownable {

    
    string _name = "NFT NAME";
    string _symbol = "SYMBOL";
    string private _baseUriExtended;
    uint256 public MAX_SUPPLY = 10_000;
    uint256 public _mintPrice;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    uint16 ES99 = 2099;
    uint16 V23 = 3223;
    uint16 LI = 4678;
  
    constructor () ERC721A(_name, _symbol) {
        require(MAX_SUPPLY == ES99 + V23 + LI);
    }

    function mint(uint256[] memory nftIds) external whenNotPaused payable {
        (uint256 phaseLimit, address whitelistNft) = getPhaseAndWhitelistAddress();
        require(totalSupply() + nftIds.length <= phaseLimit , "Max limit reached");
        require(msg.value == _mintPrice * nftIds.length, "Invalid eth");

        for (uint256 indx = 0; indx < nftIds.length; indx++) {
            IERC721A(whitelistNft).transferFrom(msg.sender, DEAD, nftIds[indx]);
           }
           uint256 quantity = nftIds.length - 1;
             _mint(msg.sender , quantity);
    }

    function withdrawEth(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient funds");
        payable(owner()).transfer(amount);
    }
    
    function setBaseURI(string memory baseURI_) external onlyOwner {
        require(bytes(baseURI_).length > 0, "baseURI is null");
        _baseUriExtended = baseURI_;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUriExtended;
    }

    function setMintPrice(uint256 _price) external onlyOwner {
        _mintPrice = _price;
    }

   
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function getPhaseAndWhitelistAddress()
    public
    view
    returns(uint256, address)
    {
        uint256 phaseLimit;
        address whitelistAddress;
        if(totalSupply() < ES99) {
            phaseLimit = ES99;
            whitelistAddress = 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8;
        } else if(totalSupply() < ES99 + V23) {
            phaseLimit += V23; 
            whitelistAddress = 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8;
        } else if(totalSupply() < ES99 + V23 + LI) {
            phaseLimit += LI;
            whitelistAddress = 0xf8e81D47203A594245E36C48e151709F0C19fBe8;
        } else {
            revert("Max supply reached");
        }
        return(phaseLimit, whitelistAddress);
    }  
}
