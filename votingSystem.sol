// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election {
    // Struct for a candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // State variables
    address public owner;
    bool public electionStarted;
    uint256 public candidateCount;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public votes;

    // Modifier to restrict access to owner-only functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Constructor to initialize the contract owner
    constructor() {
        owner = msg.sender;
        electionStarted = false;
        candidateCount = 0;
    }

    // Function to register a candidate (only owner can register)
    function registerCandidate(string memory name) public onlyOwner {
        require(!electionStarted, "Cannot register candidates after the election has started.");

        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, name, 0);
    }

    // Function to start the election (only owner can start)
    function startElection() public onlyOwner {
        electionStarted = true;
    }

    // Function to cast a vote
    function vote(uint256 candidateId) public {
        require(electionStarted, "Election has not started yet.");
        require(!votes[msg.sender], "You have already voted.");
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID.");

        candidates[candidateId].voteCount++;
        votes[msg.sender] = true;
    }

    // Function to end the election (only owner can end)
    function endElection() public onlyOwner {
        electionStarted = false;
    }

    // Function to get the vote count of a candidate
    function getCandidateVoteCount(uint256 candidateId) public view returns (uint256) {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID.");
        return candidates[candidateId].voteCount;
    }
}
