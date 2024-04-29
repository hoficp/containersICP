import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

// Governance proposal type
type Proposal = {
    id: Nat;
    description: Text;
    creator: Principal;
    votesFor: Nat;
    votesAgainst: Nat;
    startTime: Time.Time;
    endTime: Time.Time;
    executed: Bool;
};

// State of the governance canister
actor GovernanceCanister {
    private var proposals: [Proposal] = [];
    private var nextProposalId: Nat = 1;

    // Function to create a new proposal
    public func createProposal(description: Text, duration: Time.Duration) : async Nat {
        let currentTime = Time.now();
        let newProposal: Proposal = {
            id = nextProposalId,
            description = description,
            creator = Principal.fromActor(this),
            votesFor = 0,
            votesAgainst = 0,
            startTime = currentTime,
            endTime = currentTime + duration,
            executed = false
        };
        proposals := Array.append<Proposal>(proposals, [newProposal]);
        nextProposalId += 1;
        return newProposal.id;
    }

    // Function to vote on a proposal
    public func voteOnProposal(proposalId: Nat, support: Bool) : async Bool {
        let currentTime = Time.now();
        for (var proposal in proposals) {
            if (proposal.id == proposalId && currentTime < proposal.endTime) {
                if (support) {
                    proposal.votesFor += 1;
                } else {
                    proposal.votesAgainst += 1;
                };
                return true;
            };
        };
        return false;
    }

    // Function to execute a proposal
    public func executeProposal(proposalId: Nat) : async Bool {
        let currentTime = Time.now();
        for (var proposal in proposals) {
            if (proposal.id == proposalId && !proposal.executed && currentTime > proposal.endTime) {
                if (proposal.votesFor > proposal.votesAgainst) {
                    // Placeholder for the execution logic
                    proposal.executed = true;
                    return true;
                };
            };
        };
        return false;
    }

    // Function to list all proposals
    public query func listProposals() : async [Proposal] {
        return proposals;
    }
}
