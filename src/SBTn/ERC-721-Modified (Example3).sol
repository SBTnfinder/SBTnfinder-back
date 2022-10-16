// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface NFTInterface{
    function ownerOf(uint256 tokenId) external view returns (address owner);  
}

contract SbtN3 is ERC721, ERC721URIStorage, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("SBTn3", "SBTN3") {}

    //mapping attaching NFT items to an EOA address
    mapping(address => mapping(uint => address)) public nftGroup;

    //bool variable to define when the SBTn transfer should work or not
    //it's set to true when a primary NFT owner claim SBTns related to his NFT,
    //at the same transaction it transfer the token and sets the variable to false
    bool isClaiming = false;

    function safeMint(address _collectionAddress, uint256 _nftItem) public {
        NFTInterface NFTContract = NFTInterface(_collectionAddress);
        address to = NFTContract.ownerOf(_nftItem);
        require(to == msg.sender, "not NFT owner");
        nftGroup[_collectionAddress][_nftItem] = to;
        
        string memory uri = "https://gateway.pinata.cloud/ipfs/QmdeCM6yyjpxoqM35xNVJ1tibUMC7zhpcpt99wbDkNmo4Q";
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function newOwnerClaim (address _collectionAddress, uint256 _nftItem, uint256 _tokenId) public {
        NFTInterface NFTContract = NFTInterface(_collectionAddress);
        address to = NFTContract.ownerOf(_nftItem);
        require(to == msg.sender, "not NFT owner");
        
        isClaiming = true;
        _transfer(nftGroup[_collectionAddress][_nftItem], to, _tokenId);
        isClaiming = false;
        nftGroup[_collectionAddress][_nftItem] = to;
    }

    //the transfer is only allowed in those cases:
    //if token from is equal to 0, which means a mint token
    //if token to is equal to 0, which means burn token
    //if isClaiming is set to true, it's made temporarily during the newOwnerClaim()
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override (ERC721, ERC721Enumerable) {
        tokenId;
        require(
            from == address(0) || to == address(0) || isClaiming,
            "You can't transfer, it's a Soulbound token."
        );
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
