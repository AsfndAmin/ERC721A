// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";


contract uthopiaDapp is ERC721A, Ownable  {


    string private _baseUriExtended;
    uint256 public MAX_SUPPLY;
    uint256 public MAX_MINT_LIMIT;
    uint256 public _pricePerMint;
    mapping(address => uint8) public userMintedNft;
  
    constructor (string memory name_, string memory symbol_, uint256 mintPrice_, uint256 maxSupply_) ERC721A(name_, symbol_) {
        MAX_SUPPLY = maxSupply_;
        _pricePerMint = mintPrice_;
    }

    function mint(uint256 amount) external payable {
        require(totalSupply() + amount <= MAX_SUPPLY , "Max limit reached");
        require(msg.value == _pricePerMint * amount, "Invalid eth");
        require(userMintedNft[msg.sender] + amount <= MAX_MINT_LIMIT, "Cannot mint more");

       
            _mint(msg.sender , amount);
      
        userMintedNft[msg.sender] += uint8(amount);
    }

    function withdrawEth(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient funds");
        payable(owner()).transfer(amount);
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        require(bytes(baseURI_).length > 0, "baseURI is null");
        _baseUriExtended = baseURI_;
    }

    function setMaxMintLimit(uint256 _newLimit) external onlyOwner {
        MAX_MINT_LIMIT = _newLimit;
    }

    function setMintPrice(uint256 price) external onlyOwner {
        _pricePerMint = price;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        MAX_SUPPLY = _maxSupply;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUriExtended;
    }


}
