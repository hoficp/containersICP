import Array "mo:base/Array";
import Principal "mo:base/Principal";

// Define the NFT data structure
public type NFT = {
    id: Nat,
    owner: Principal,
    metadata: Metadata
};

// Define the metadata structure for an NFT
public type Metadata = {
    name: Text,
    description: Text,
    image: Text, // URL or IPFS link
    attributes: [(Text, Text)]
};

// Define the state of the canister
actor class NFTCanister(owner: Principal) {
    private var nfts: [NFT] = [];
    private var nextId: Nat = 1;

    // Initialize the canister with the owner
    public func init() : async () {
        owner := Principal.fromActor(this);
    }

    // Mint a new NFT
    public func mintNFT(metadata: Metadata) : async NFT {
        let newNFT: NFT = {
            id = nextId,
            owner = owner,
            metadata = metadata
        };
        nfts := Array.append<NFT>(nfts, [newNFT]);
        nextId += 1;
        return newNFT;
    }

    // Get an NFT by ID
    public func getNFT(id: Nat) : async ?NFT {
        return Array.find<NFT>(nfts, func (n) { n.id == id });
    }

    // Transfer ownership of an NFT
    public func transferNFT(nftId: Nat, newOwner: Principal) : async Bool {
        for (nft in nfts) {
            if (nft.id == nftId and nft.owner == Principal.fromActor(this)) {
                nft.owner := newOwner;
                return true;
            }
        };
        return false;
    }
};
