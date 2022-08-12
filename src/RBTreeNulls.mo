import Debug "mo:base/Debug";

module RBTree {

  type Node = {
    var red: Bool;
    var parent: ?Node;
    key: Text;
    var value: Nat;
    var left: ?Node;
    var right: ?Node;
  };

  public type RBTree = {
    var tree : ?Node;
  };


  public func empty(): RBTree = { 
    var tree = null;
  };

  func initNode(key: Text, value: Nat): Node {
    {
      var red = true;
      var parent = null;
      key = key;
      var value = value;
      var left = null;
      var right = null;
    }
  };

  public func get(root: RBTree, key: Text): ?Nat {
    getHelper(root.tree, key);
  };

  func getHelper(node: ?Node, key: Text): ?Nat {
    switch(node) {
      case null { null };
      case (?n) {
        if (key == n.key) { ?n.value }
        else if (key < n.key) { getHelper(n.left, key) } 
        else { getHelper(n.right, key) }
      }
    }
  };

  public func insert(root: RBTree, key: Text, value: Nat): () {
    var node = initNode(key, value);

    var tree = root.tree;
    var parent: ?Node = null;


    label l loop {
      switch(tree) {
        case null { break l };
        case (?t) {
          parent := tree;
          if (node.key < t.key) {
            tree := t.left;
          } else if (node.key == t.key) {
            t.value := node.value;
            return;
          } else {
            tree := t.right;
          };
        } 
      }
    };

    node.parent := parent;
    switch(parent) {
      case null {
        node.red := false;
        root.tree := ?node;
        return;
      };
      case (?p) {
        if (node.key < p.key) {
          p.left := ?node;
        } else {
          p.right := ?node;
        };

        switch(p.parent) {
          case null { return };
          case (?gp) {
            fitInsert(root, node, p, gp);
          }
        }
      }
    };
  };

  // If necessary, fix node red/black coloring and rotate 
  func fitInsert(root: RBTree, n: Node, parent: Node, gp: Node): () {
    var node = n;
    label l loop {
      if (nodeKeyEquals(?parent, gp.right)) {
        switch(gp.left) {
          case null { 
            if (nodeKeyEquals(?node, parent.left)) {
              node := parent;
              rightRotate(root, node)
            };

            parent.red := false;
            gp.red := true;
            leftRotate(root, gp)
          };
          case (?uncle) {
            if (uncle.red == true) {
              uncle.red := false;
              parent.red := false;
              gp.red := true;
              node := gp;
            } else {
              if (nodeKeyEquals(?node, parent.left)) {
                node := parent;
                rightRotate(root, node)
              };

              parent.red := false;
              gp.red := true;
              leftRotate(root, gp)
            } 
          }
        }
      } else {
        switch(gp.right) {
          case null { 
            if (nodeKeyEquals(?node, parent.right)) {
              node := parent;
              leftRotate(root, node)
            };

            parent.red := false;
            gp.red := true;
            rightRotate(root, gp)
          };
          case (?uncle) {
            if (uncle.red == true) {
              uncle.red := false;
              parent.red := false;
              gp.red := true;
            } else {
              if (nodeKeyEquals(?node, parent.right)) {
                node := parent;
                leftRotate(root, node)
              };

              parent.red := false;
              gp.red := true;
              rightRotate(root, gp)
            }
          }
        }
      };

      if (nodeKeyEquals(?node, root.tree)) {
        break l;
      };

    } while (parent.red == true);

    switch(root.tree) {
      case null { assert false };
      case (?t) { t.red := false }
    }
  };

  func leftRotate(root: RBTree, node: Node): () {
    switch(node.right) {
      case null { /*TODO assert false? */ };
      case (?parent) {
        node.right := parent.left;
        switch(parent.left) {
          case null {};
          case (?lp) {
            lp.parent := ?node;
          };
        };
        parent.parent := node.parent;
        
        switch(node.parent) {
          case null { root.tree := ?parent };
          case (?p) {
            if (nodeKeyEquals(?node, p.left)) {
              p.left := ?parent;
            } else {
              p.right := ?parent;
            }
          }
        };

        parent.left := ?node;
        node.parent := ?parent;
      }
    }
  };


  func rightRotate(root: RBTree, node: Node): () {
    switch(node.left) {
      case null { /*TODO assert false? */ };
      case (?parent) {
        node.left := parent.right;
        switch(parent.right) {
          case null {};
          case (?rp) {
            rp.parent := ?node;
          };
        };
        parent.parent := node.parent;
        
        switch(node.parent) {
          case null { root.tree := ?parent };
          case (?p) {
            if (nodeKeyEquals(?node, p.right)) {
              p.right := ?parent;
            } else {
              p.left := ?parent;
            }
          }
        };

        parent.right := ?node;
        node.parent := ?parent;
      }
    }
  };

  func nodeKeyEquals(n1: ?Node, n2: ?Node): Bool {
    switch(n1, n2) {
      case (null, null) { true };
      case (?n1, ?n2) { n1.key == n2.key };
      case _ { false }
    }
  };

  public func debugShow(node: ?Node): Text {
    switch(node) {
      case null { "null" };
      case (?n) {
        "node: {key=" # n.key # "; value=" # debug_show(n.value) # "; red=" # debug_show(n.red) # "; left=" # debugShow(n.left) # "; parent=ignore; right=" # debugShow(n.right) # "}";
      }
    }
  }
}
  