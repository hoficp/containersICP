import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Random "mo:base/Random";

// Define the Ticket data structure
type Ticket = {
    id: Nat,
    owner: Principal,
    luck: Nat // A value that influences the chance of winning
};

// Define the state of the canister
actor LotteryCanister {
    private var tickets: [Ticket] = [];
    private var nextTicketId: Nat = 1;
    private var lotteryOpen: Bool = true;

    // Initialize the lottery
    public func openLottery() : async () {
        lotteryOpen := true;
        tickets := [];
        nextTicketId := 1;
    }

    // Close the lottery for new entries
    public func closeLottery() : async () {
        lotteryOpen := false;
    }

    // Register a new ticket
    public func registerTicket(owner: Principal, luck: Nat) : async Nat {
        if (lotteryOpen) {
            let newTicket: Ticket = {
                id = nextTicketId,
                owner = owner,
                luck = luck
            };
            tickets := Array.append<Ticket>(tickets, [newTicket]);
            nextTicketId += 1;
            return newTicket.id;
        } else {
            throw "Lottery is closed";
        }
    }

    // Draw a winner based on their luck value
    public func drawWinner() : async ?Ticket {
        if (Array.size<Ticket>(tickets) == 0) {
            return null;
        };

        closeLottery();

        let totalLuck = Array.foldLeft<Ticket, Nat>(tickets, 0, func (acc, t) {
            acc + t.luck
        });

        let randomPoint = Random.randNat(totalLuck);

        let winner = Array.reduce<Ticket, ?Ticket>(tickets, null, func (currentWinner, t) {
            let newAcc = switch (currentWinner) {
                case (null) { t.luck };
                case (?cw) { cw.luck + t.luck };
            };
            if (newAcc <= randomPoint) {
                ?t
            } else {
                currentWinner
            }
        });

        return winner;
    }
};
