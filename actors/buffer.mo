import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Prim "mo:prim";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";


actor Echo {
  var buffer = Buffer.Buffer<Text>(0);
  var itemCount = 0;

  //////////////////////////////////////////////////////////////////////////////////////////////////
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

  public func testBufferThroughput(count: Nat) : async Nat {
    let end = itemCount + count;

    for (item in Iter.range(itemCount, end)) buffer.add(Nat.toText(item));

    itemCount := end;

    return end;
  };

  public func getBufferItemsCount(): async Nat {
    itemCount
  };


  public func clear(): () {
    buffer := Buffer.Buffer<Text>(0);
    itemCount := 0;
  };
};