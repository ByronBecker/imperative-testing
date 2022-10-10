import RBTree "../src/RBTreeNulls";
import RBCheck "RBTreeCheck";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

let amount = 100_000;

func testAscendingInserts() {
    let tree = RBTree.empty();
    for (count in Iter.range(0, amount - 1)) {
        RBTree.insert(tree, debug_show(count), count)
    };
    RBCheck.check(tree);
    for (count in Iter.range(0, amount - 1)) {
        assert(RBTree.get(tree, debug_show(count)) == ?count)
    }
};

func testDescedingInserts() {
    let tree = RBTree.empty();
    for (count in Iter.range(0, amount - 1)) {
        RBTree.insert(tree, debug_show(-count), count)
    };
    RBCheck.check(tree);
    for (count in Iter.range(0, amount - 1)) {
        assert(RBTree.get(tree, debug_show(-count)) == ?count)
    }
};

func testRandomInserts() {
    object Random {
        var state = 4711;
        public func next() : Nat {
            state := (123138118391*state + 133489131) % 9999;
            state
        }
    };
    let tree = RBTree.empty();
    for (count in Iter.range(0, amount)) {
        let number = Random.next();
        RBTree.insert(tree, debug_show(number), number);
        assert(RBTree.get(tree, debug_show(number)) == ?number);
    };
    RBCheck.check(tree)
};

testAscendingInserts();
testDescedingInserts();
testRandomInserts();
Debug.print("All tests passed.")
