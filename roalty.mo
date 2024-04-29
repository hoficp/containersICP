import Principal "mo:base/Principal";

// Define the structure to store NFT royalty info
type NFTRoyaltyInfo = {
    creator: Principal;
    royaltyPercentage: Float; // Percentage of resale price to pay as royalty
};

// Define the structure for NFT ownership and sale records
type NFTOwnership = {
    currentOwner: Principal;
    previousSalePrice: Nat;
};

// State of the royalty management canister
actor RoyaltyManagementCanister {
    private var royalties: [NFTRoyaltyInfo] = [];
    private var ownerships: [NFTOwnership] = [];
    private var nextNftId: Nat = 1;

    // Register an NFT with royalty info
    public func registerNFT(creator: Principal, royaltyPercentage: Float) : async Nat {
        let nftId = nextNftId;
        let royaltyInfo = NFTRoyaltyInfo { creator = creator, royaltyPercentage = royaltyPercentage };
        royalties := royalties + [royaltyInfo];
        ownerships := ownerships + [NFTOwnership { currentOwner = creator, previousSalePrice = 0 }];
        nextNftId += 1;
        return nftId;
    }

    // Record a resale of an NFT and calculate royalty payment
    public func resaleNFT(nftId: Nat, newOwner: Principal, salePrice: Nat) : async ?Nat {
        for (var i = 0; i < royalties.size(); i += 1) {
            if (i + 1 == nftId) {
                let royaltyInfo = royalties[i];
                let ownership = ownerships[i];
                let royaltyPayment = (salePrice * royaltyInfo.royaltyPercentage) / 100;

                // Transfer the royalty payment to the creator (pseudo code)
                // await transferFunds(royaltyInfo.creator, royaltyPayment);

                // Update ownership and sale price record
                ownership.currentOwner := newOwner;
                ownership.previousSalePrice := salePrice;
                ownerships[i] := ownership;

                return ?royaltyPayment;
            }
        };
        return null; // NFT not found
    }

    // Query to get NFT ownership info
    public query func getNFTOwnership(nftId: Nat) : async ?NFTOwnership {
        if (nftId <= ownerships.size()) {
            return ?ownerships[nftId - 1];
        } else {
            return null;
        }
    }
}
import Principal "mo:base/Principal";

// Define the structure to store NFT royalty info
type NFTRoyaltyInfo = {
    creator: Principal;
    royaltyPercentage: Float; // Percentage of resale price to pay as royalty
};

// Define the structure for NFT ownership and sale records
type NFTOwnership = {
    currentOwner: Principal;
    previousSalePrice: Nat;
};

// State of the royalty management canister
actor RoyaltyManagementCanister {
    private var royalties: [NFTRoyaltyInfo] = [];
    private var ownerships: [NFTOwnership] = [];
    private var nextNftId: Nat = 1;

    // Register an NFT with royalty info
    public func registerNFT(creator: Principal, royaltyPercentage: Float) : async Nat {
        let nftId = nextNftId;
        let royaltyInfo = NFTRoyaltyInfo { creator = creator, royaltyPercentage = royaltyPercentage };
        royalties := royalties + [royaltyInfo];
        ownerships := ownerships + [NFTOwnership { currentOwner = creator, previousSalePrice = 0 }];
        nextNftId += 1;
        return nftId;
    }

    // Record a resale of an NFT and calculate royalty payment
    public func resaleNFT(nftId: Nat, newOwner: Principal, salePrice: Nat) : async ?Nat {
        for (var i = 0; i < royalties.size(); i += 1) {
            if (i + 1 == nftId) {
                let royaltyInfo = royalties[i];
                let ownership = ownerships[i];
                let royaltyPayment = (salePrice * royaltyInfo.royaltyPercentage) / 100;

                // Transfer the royalty payment to the creator (pseudo code)
                // await transferFunds(royaltyInfo.creator, royaltyPayment);

                // Update ownership and sale price record
                ownership.currentOwner := newOwner;
                ownership.previousSalePrice := salePrice;
                ownerships[i] := ownership;

                return ?royaltyPayment;
            }
        };
        return null; // NFT not found
    }

    // Query to get NFT ownership info
    public query func getNFTOwnership(nftId: Nat) : async ?NFTOwnership {
        if (nftId <= ownerships.size()) {
            return ?ownerships[nftId - 1];
        } else {
            return null;
        }
    }
}
