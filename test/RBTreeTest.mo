import RBT "../src/RBTreeNulls";

import Debug "mo:base/Debug";


var t = RBT.empty();

Debug.print("t: " # debug_show(t));

RBT.insert(t, "d", 5);

Debug.print("t: " # debug_show(t));

RBT.insert(t, "b", 6);

Debug.print("t: " # RBT.debugShow(t.tree));

RBT.insert(t, "a", 10);
Debug.print("t: " # RBT.debugShow(t.tree));
RBT.insert(t, "c", 7);
Debug.print("t: " # RBT.debugShow(t.tree));
RBT.insert(t, "c", 9);
Debug.print("t: " # RBT.debugShow(t.tree));

Debug.print("a: " # debug_show(RBT.get(t, "a")));
Debug.print("b: " # debug_show(RBT.get(t, "b")));
Debug.print("c: " # debug_show(RBT.get(t, "c")));
Debug.print("d: " # debug_show(RBT.get(t, "d")));
Debug.print("f: " # debug_show(RBT.get(t, "f")));