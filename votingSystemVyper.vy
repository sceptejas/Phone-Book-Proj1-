# SPDX-License-Identifier: MIT
# Voting smart contract in Vyper for a simple election

from vyper.interfaces import ERC20

# Struct for a candidate
struct Candidate:
    id: uint256
    name: String[64]
    voteCount: uint256

# State variables
owner: public(address)
electionStarted: public(bool)
candidates: public(HashMap[uint256, Candidate])
candidateCount: public(uint256)
votes: public(HashMap[address, bool])

@external
def __init__():
    self.owner = msg.sender
    self.electionStarted = False
    self.candidateCount = 0

# Modifier for functions only accessible by the owner
@internal
def onlyOwner() -> bool:
    return msg.sender == self.owner

# Register a candidate
@external
def register_candidate(name: String[64]):
    assert self.onlyOwner(), "Only the owner can register candidates."
    assert not self.electionStarted, "Cannot register candidates after the election has started."

    self.candidateCount += 1
    self.candidates[self.candidateCount] = Candidate({
        id: self.candidateCount,
        name: name,
        voteCount: 0
    })

# Start the election
@external
def start_election():
    assert self.onlyOwner(), "Only the owner can start the election."
    self.electionStarted = True

# Cast a vote
@external
def vote(candidateId: uint256):
    assert self.electionStarted, "Election has not started yet."
    assert not self.votes[msg.sender], "You have already voted."
    assert candidateId > 0 and candidateId <= self.candidateCount, "Invalid candidate ID."

    self.candidates[candidateId].voteCount += 1
    self.votes[msg.sender] = True

# End the election
@external
def end_election():
    assert self.onlyOwner(), "Only the owner can end the election."
    self.electionStarted = False

# Get total votes for a candidate
@external
@view
def get_candidate_vote_count(candidateId: uint256) -> uint256:
    assert candidateId > 0 and candidateId <= self.candidateCount, "Invalid candidate ID."
    return self.candidates[candidateId].voteCount
