// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFT3 is Ownable, ERC721("Example3", "EMP3"){

    uint tokenId;
    mapping(address=>tokenMetaData[]) public ownershipRecord;

    struct tokenMetaData{
        uint tokenId;
        uint timeStamp;
        string tokenURI;
    }

    function mintToken(address recipient) onlyOwner public {

        require(owner()!=recipient, "Recipient cannot be the owner of the contract");
       
        _safeMint(recipient, tokenId);
        ownershipRecord[recipient].push(tokenMetaData(tokenId, block.timestamp, "https://gateway.pinata.cloud/ipfs/QmUnbr5UwpZwBVauQHAW8TGc3gC7o5xNX9V49QEyRzrGaR"));
        tokenId = tokenId + 1;
    }
}