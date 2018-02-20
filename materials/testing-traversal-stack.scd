

a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
a.cs
a.subTraversal(0).cs;
a.subTraversal(1).cs;
a.subTraversal(2).cs;
a.subTraversal(3).cs;

a.scaling
b = a.subTraversal(0);

b.scaling



(
a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
t = TraversalStack(a, [0, 0, 0]);


~path = (16 * 4).collect {
	var res;
	t.value { |x, i|
		res = x.locations[i].postln
	};
	t.next;
	res
};

f = { |reihe, title = "untitled", width = 500, dur = 0.1|

	var max, min, step, scale, mid;

	max = reihe.flat.maxItem;
	min = reihe.flat.minItem;
	scale = max - min;
	p = reihe.collect { |pair|
		pair = pair.postln.linlin(min, max, 10, width/2 - 10);
		Point(*pair)
	};

	w = Window(title, Rect(340, 40, width, width));
	w.background = Color.white;
	w.front;

	{
		var j = 0;
		var offset = w.view.bounds.width div: 2;

		w.drawFunc = {
			Pen.matrix = [1, 0, 0, -1, offset/2, offset*3/2];
			Pen.strokeColor = Color.black;
			Pen.smoothing = false;
			Pen.moveTo(p @ 0);
			p.keep(j).do { |point|
				Pen.lineTo(point);
			};

			Pen.stroke;
			j = j + 1;
		};
		fork({ while { w.isClosed.not } { dur.wait; w.refresh; } }, AppClock);
	}.value;
};
f.(~path);
)

