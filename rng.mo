import Nat "mo:base/Nat";
import Random "mo:base/Random";

// RNG Canister
actor RNGCanister {

    // Generates a random number within a specified range
    public func generateRandom(max: Nat) : async Nat {
        return Random.randNat(max);
    }

    // Generates a cryptographically secure random number
    // Note: For illustration, this uses the same Random module, but in a real-world scenario, 
    // you might need to integrate a more secure source of randomness depending on the application requirements.
    public func generateSecureRandom(max: Nat) : async Nat {
        // This example simply uses Random's randNat, but you should implement or integrate a VRF (Verifiable Random Function)
        // or similar technology for applications that require cryptographic security.
        return Random.randNat(max);
    }
}
