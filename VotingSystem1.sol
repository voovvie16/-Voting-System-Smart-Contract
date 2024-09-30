// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public owner;
    mapping(address => bool) public hasVoted;
    mapping(string => uint256) public voteCounts;

    event Voted(address indexed voter, string party);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }

    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function vote(string memory party) external hasNotVoted {
        require(
            keccak256(abi.encodePacked(party)) ==
                keccak256(abi.encodePacked("BJP")) ||
                keccak256(abi.encodePacked(party)) ==
                keccak256(abi.encodePacked("Congress")) ||
                keccak256(abi.encodePacked(party)) ==
                keccak256(abi.encodePacked("Others")) ||
                keccak256(abi.encodePacked(party)) ==
                keccak256(abi.encodePacked("NOTA")),
            "Invalid party"
        );

        hasVoted[msg.sender] = true;
        voteCounts[party]++;
        emit Voted(msg.sender, party);
    }

    function getVoteCount(string memory party) external view returns (uint256) {
        return voteCounts[party];
    }

    function getWinner() external view returns (string memory) {
        require(msg.sender == owner, "Only the owner can get the winner");

        string memory winner;
        uint256 maxVotes = 0;

        if (voteCounts["BJP"] > maxVotes) {
            maxVotes = voteCounts["BJP"];
            winner = "BJP";
        }

        if (voteCounts["Congress"] > maxVotes) {
            maxVotes = voteCounts["Congress"];
            winner = "Congress";
        }

        if (voteCounts["Others"] > maxVotes) {
            maxVotes = voteCounts["Others"];
            winner = "Others";
        }

        if (voteCounts["NOTA"] > maxVotes) {
            winner = "NOTA";
        }

        return winner;
    }
}
