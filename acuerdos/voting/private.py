# Placeholder for SPADE-BDI integration
import asyncio
import spade
from spade_bdi.bdi import BDIAgent
import random
import matplotlib.pyplot as plt
from collections import Counter

NUM_VOTERS = 100
CANDIDATES = ['alice', 'bob', 'carol']

class VotingRegulator(BDIAgent):
    def __init__(self, jid, password, asl_path):
        super().__init__(jid, password, asl_path)

class VoterAgent(BDIAgent):
    def __init__(self, jid, password, asl_path):
        super().__init__(jid, password, asl_path)

async def main():
    print("Starting Voting simulation with SPADE-BDI...")
    # Prepare voter names
    voter_names = [f"voter{i+1}" for i in range(NUM_VOTERS)]
    # Write the all_voters belief to regulator.asl
    with open("regulator.asl", "r") as f:
        lines = f.readlines()
    # Remove any existing all_voters line
    lines = [line for line in lines if not line.strip().startswith("all_voters(")]
    # Add the new all_voters belief at the end
    lines.append(f"all_voters({voter_names}).\n")
    with open("regulator.asl", "w") as f:
        f.writelines(lines)

    # Start regulator
    regulator = VotingRegulator("regulator@localhost", "1234", "regulator.asl")
    await regulator.start()

    # Start 100 voters
    voters = []
    for i in range(NUM_VOTERS):
        voter_jid = f"voter{i+1}@localhost"
        voter = VoterAgent(voter_jid, "1234", "voter.asl")
        await voter.start()
        voters.append(voter)

    print(f"Started {NUM_VOTERS} voters and regulator. Waiting for voting to complete...")
    # Give time for agents to vote and regulator to process
    await asyncio.sleep(10)

    # Collect votes from the regulator's belief base (simulate for now)
    # In a real system, you would query the regulator agent for the votes
    # Here, we simulate the result as before for demonstration
    votes = []
    for _ in range(NUM_VOTERS):
        shuffled = CANDIDATES[:]
        random.shuffle(shuffled)
        votes.append(shuffled[0])

    vote_counts = Counter(votes)
    print("Vote counts:", vote_counts)
    print("Winner:", vote_counts.most_common(1)[0][0])

    plt.bar(vote_counts.keys(), vote_counts.values(), color=['red', 'green', 'blue'])
    plt.xlabel('Candidate')
    plt.ylabel('Number of Votes')
    plt.title('Voting Results Histogram (100 voters)')
    plt.show()

    print("Stopping agents...")
    await regulator.stop()
    for voter in voters:
        await voter.stop()
    print("Agents stopped.")

if __name__ == "__main__":
    spade.run(main())
