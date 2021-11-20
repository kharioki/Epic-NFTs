// SPDX-LICENSE-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {
    // use counter to keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // pass name of our NFTs token and it's symbol
    constructor() ERC721("KikiNFT", "KHK") {
        console.log("Checkout my NFT contract!");
    }

    // function to get NFT
    function makeAnEpicNFT() public {
        // get current tokenId, starts at 0
        uint256 newItemId = _tokenIds.current();

        // mint new NFT
        _safeMint(msg.sender, newItemId);

        // set the NFTs data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/47WN");
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // increase counter
        _tokenIds.increment();
    }
}
