  import RBTree "../src/RBTreeNulls";

  module {
    public func check(tree: RBTree.RBTree) {
        ignore blackDepth(tree.tree)
    };

    func blackDepth(node: ?RBTree.Node): Nat {
        switch node {
        case null 0;
            case (?current) {
                checkParent(current.left, current);
                checkParent(current.right, current);
                let leftBlacks = blackDepth(current.left);
                let rightBlacks = blackDepth(current.right);
                assert(leftBlacks == rightBlacks);
                if (current.red) {
                    assert(not isRed(current.left));
                    assert(not isRed(current.right));
                    leftBlacks
                } else {
                    leftBlacks + 1
                }
            }
        } 
    };

    func isRed(node: ?RBTree.Node): Bool {
        switch node {
            case null false;
            case (?current) current.red
        }
    };

    func checkParent(child: ?RBTree.Node, parent: RBTree.Node) {
        switch child {
            case null {};
            case (?current) {
                switch (current.parent) {
                    case null assert(false);
                    case (?test) assert(test.key == parent.key)
                }
            } 
        }
    }
  }
  