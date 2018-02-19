

a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
t = TraversalStack(a, [0, 0]);

(
200.do {
	t.value { |x, i| x.locations[i].postln };
	t.next;
}
)

