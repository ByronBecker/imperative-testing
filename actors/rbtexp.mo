import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Prim "mo:prim";
import RBT "../src/RBTImperativeNoDelete";
import Cycles "mo:base/ExperimentalCycles";


actor Echo {
  stable var stableRBTreeBlob = RBT.empty<Blob>();
  stable var stableRBTreeNat = RBT.empty<Nat>();

  stable var blobItemCount = 0;
  stable var natItemCount = 0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // Util APIs

  type CanisterMetrics = {
    heapSize: Nat; 
    cycles: Nat;
  };

  public func getCanisterMetrics() : async CanisterMetrics {
    {
      heapSize = Prim.rts_heap_size();
      cycles = Cycles.balance();
    }
  };

  // clears the RBT (does not clear the heap, would need to do a fresh re-install for this)
  public func clear(): () {
    stableRBTreeBlob := RBT.empty<Blob>();
    stableRBTreeNat := RBT.empty<Nat>();
    blobItemCount := 0;
    natItemCount := 0;
  };

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // RBTreeBlob APIs

  // used for testing out uploading a 1MB chunk into the RBTree
  public func uploadChunk(id: Text, chunk: Blob): async Nat {
    RBT.insert<Blob>(stableRBTreeBlob, id, chunk);

    blobItemCount += 1;

    return blobItemCount;
  };

  public func getRBTreeBlobElementsCount(): async Nat {
    blobItemCount 
  };

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // RBTreeNat APIs

  // test how many Nat (small) items can be inserted into an existing RBTree in a round of consensus
  public func testRBTreeNatThroughout(count: Nat) : async Nat {
    let end = natItemCount + count;

    for (item in Iter.range(natItemCount, end)) RBT.insert<Nat>(stableRBTreeNat, Nat.toText(item), item+1);

    natItemCount += count;

    return end;
  };

  

  public func getRBTreeNatItem(k: Text): async ?Nat {
    RBT.get<Nat>(stableRBTreeNat, k);
  };

  public func hasNatItemWithKey(k: Text): async ?Text {
    if (RBT.has<Nat>(stableRBTreeNat, k)) ?k else null;
  };

  public func getRBTreeNatElementsCount(): async Nat {
    natItemCount 
  };
};