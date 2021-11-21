// SPDX-LICENSE-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    // use counter to keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // lets make a baseSVG variable here that all our NFTs can use
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // random words arrays
    string[] firstWords = [
        "Ironman",
        "Spiderman",
        "Antman",
        "CaptainAmerica",
        "Hawkeye",
        "Thor",
        "Hulk",
        "BlackWidow",
        "DoctorStrange",
        "BlackPanther",
        "CaptainMarvel",
        "Vision",
        "Loki",
        "Groot",
        "Rocket",
        "StarLord",
        "DoctorStrange",
        "WinterSoldier",
        "ScarletWitch"
    ];
    string[] secondWords = [
        "Pizza",
        "Ugali",
        "Pineapple",
        "Banana",
        "Chocolate",
        "Apple",
        "Pepper",
        "Orange",
        "Burger",
        "Sushi",
        "Sharwarma",
        "Croissant",
        "Muffins",
        "Chicken",
        "Sandwich",
        "Crepe",
        "Bread"
    ];
    string[] thirdWords = [
        "Nairobi",
        "Westlands",
        "Nanyuki",
        "Kisumu",
        "Eldoret",
        "Nyeri",
        "Embu",
        "Meru",
        "Machakos",
        "Kajiado",
        "Naivasha",
        "Kitui",
        "Kisii",
        "Mombasa",
        "Voi",
        "Thika",
        "Kakamega",
        "Lamu",
        "Malindi",
        "Maasaimara",
        "Tsavo"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // pass name of our NFTs token and it's symbol
    constructor() ERC721("KikiNFT", "KHK") {
        console.log("Checkout my NFT contract!");
    }

    // function to randomly pick a word from each array
    function pickRandomFirstWord(uint256 tokedId)
        public
        view
        returns (string memory)
    {
        // seed random generator
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokedId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokedId)
        public
        view
        returns (string memory)
    {
        // seed random generator
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokedId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokedId)
        public
        view
        returns (string memory)
    {
        // seed random generator
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokedId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // function to get NFT
    function makeAnEpicNFT() public {
        // get current tokenId, starts at 0
        uint256 newItemId = _tokenIds.current();

        // randomize words
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        // concatenate words
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        // get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // we set the title of our NFT as the generated word
                        combinedWord,
                        '", "description": "A highly acclaimed collection of possible superhero names.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // prepend data:application/json;base64
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        // mint new NFT
        _safeMint(msg.sender, newItemId);

        // set the NFTs data
        _setTokenURI(newItemId, finalTokenUri);

        // increase counter
        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
