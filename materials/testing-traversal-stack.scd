

a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
a.cs
a.subTraversal(0).cs;
a.subTraversal(0).subTraversal(0).cs;
a.subTraversal(0).subTraversal(1).cs;
a.subTraversal(0).subTraversal(2).cs;
a.subTraversal(0).subTraversal(3).cs;
a.subTraversal(1).cs;
a.subTraversal(2).cs;
a.subTraversal(3).cs;

a.scaling
b = a.subTraversal(0);

b.scaling

a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
f = { |a, i, j| a.subTraversal(i).subTraversal(j).locations };
x = { |i| { |j| f.(a, i, j) } ! 4 } ! 4;
x.flatten(2).plotPointPath




a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
t = TraversalStack(a, [0, 0]);
t.next;
t.next;
t.next;
t.next;



(
a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
t = TraversalStack(a, [0, 0]);

(16 * 4).collect {
	var res;
	t.value { |x, i|
		res = x.locations[i].postln
	};
	t.next;
	res
}.plotPointPath;
)

