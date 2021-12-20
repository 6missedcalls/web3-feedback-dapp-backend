// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 totalLikes;
    string comment;
    uint private seed;

    event NewWave(address indexed from, uint256 timestamp, string comment);
    event NewLike(address indexed from, uint256 timestamp);
    event NewComment(address indexed from, uint256 timestamp, string comment);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    struct Like {
        address liker;
        uint256 timestamp;
    }

    struct newComment {
        address commenter;
        string comment;
        uint256 timestamp;
    }

    Wave[] waves;
    Like[] likes;
    newComment[] comments;

    mapping(address => uint256) private lastAction;
    mapping(address => uint256) private lastLike;
    mapping(address => uint256) private lastComment;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        seed = (block.timestamp + block.difficulty) % 100;
    }

   function wave(string memory _message) public {
    require(lastAction[msg.sender] + block.timestamp < block.timestamp + block.difficulty, "You can't wave too fast!");
    lastAction[msg.sender] = block.timestamp;
    totalWaves += 1;
    console.log("%s has waved!", msg.sender);
    waves.push(Wave(msg.sender, _message, block.timestamp));
    seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function like() public {
        require(lastLike[msg.sender] + block.timestamp < block.timestamp + block.difficulty, "You can't like too fast!");
        lastLike[msg.sender] = block.timestamp;
        totalLikes += 1;
        console.log("%s has liked!", msg.sender);
        likes.push(Like(msg.sender, block.timestamp));
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewLike(msg.sender, block.timestamp);
    }

    function getTotalLikes() public view returns (uint256) {
        console.log("We have %d total likes!", totalLikes);
        return totalLikes;
    }

    function setComment(string memory _comment) public {
        require(lastComment[msg.sender] + block.timestamp < block.timestamp + block.difficulty, "You can't comment too fast!");
        lastComment[msg.sender] = block.timestamp;
        comment = _comment;
        console.log("%s has commented: %s", msg.sender, comment);
        comments.push(newComment(msg.sender, comment, block.timestamp));
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewComment(msg.sender, block.timestamp, comment);
    }

    function getComment() public view returns (string memory) {
        console.log("%s has commented: %s", msg.sender, comment);
        return comment;
    }
}