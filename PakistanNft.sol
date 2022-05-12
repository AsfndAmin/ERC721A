// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721ABurnable.sol";

contract pakistanNft is ERC721A, Ownable, ERC721ABurnable{

    string public baseUriExtended;
    uint256 public immutable maxSupply = 100;

    constructor (string memory name_, string memory symbol_) ERC721A(name_, symbol_) {}

    function mintnfts(address _address, uint256 _quantity) external{
        require(totalSupply() + _quantity <= maxSupply, "max supply reached");
        _safeMint(_address, _quantity);
    }

    function burn(uint256 tokenId) public override {
        _burn(tokenId, true);
    }

    function setBaseUri(string memory _baseUri) public onlyOwner{
        baseUriExtended = _baseUri;
    }

     function _baseURI() internal view override returns (string memory) {
        return baseUriExtended;
    }
}
