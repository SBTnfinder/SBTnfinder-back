// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFT2 is Ownable, ERC721("Example2", "EMP2"){

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
        ownershipRecord[recipient].push(tokenMetaData(tokenId, block.timestamp, "https://gateway.pinata.cloud/ipfs/QmZz8oEPu3pyjMASoVcSHeAXBohMBUz8yTB9b8z6LVJKKN"));
        tokenId = tokenId + 1;
    }
}