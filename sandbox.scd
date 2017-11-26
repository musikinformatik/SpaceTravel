

Quarks.install("/Volumes/data/sc/quarks/SpaceTravel");


(
g = { |w, reihe, dur, color|
	var j = 1;
	var max, min, step, scale, points;
	var width = w.view.bounds.width * 0.9;

	max = reihe.flat.maxItem;
	min = reihe.flat.minItem;
	scale = max - min;
	points = reihe.collect { |pair|
		pair = pair.linlin(min, max, 10, width - 10);
		Point(*pair)
	};

	 w.drawFunc = w.drawFunc.addFunc({
		Pen.matrix = [1, 0, 0, -1, 20 , width + 20];
		Pen.strokeColor = color;
		Pen.smoothing = false;
		Pen.width = 1;
		Pen.moveTo(points[0]);
		if(dur > 0) { points.keep(j) } { points }.do { |point| Pen.lineTo(point) };

		Pen.stroke;
		j = j + 1;
	});

};
)


// draw some...
(
var dur = 0.01;
a = SpaceTravel("< [ 2 -1 } 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >");
a.traversal.verbose = true;

w = Window("hilbert", Rect(340, 40, 340, 340));
w.background = Color.white;
w.front;

g.(w, a.traversal.generateFullPath(2).centerPath, dur, Color.black);
//g.(w, a.traversal.generateFullPath(3), dur, Color.green);
//g.(w, a.traversal.generateFullPath(4), dur, Color.red);
if(dur > 0) {
	fork({ while { w.isClosed.not } { dur.wait; w.refresh; } }, AppClock)
};
)



// some inspections
a = SpaceTravel("< [ 2 -1 } 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >");
a.traversal
a.traversal.transformations
a.traversal.directions
a.traversal.locations


// conversions
[2, -1].permute2matrix

[2,3,-1].permute2matrix.matrix2permute

(
[
	[ 0, 0, -1 ],
	[ 1, 0, 0 ],
	[ 0, 1, 0 ]
]
)

// running tests
TestArrayMatrixOps.run;



a = SpaceTravel.readFile("traversals/HarmoniousHilbert2.hx".resolveRelative);
a.traversal.transformations


a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >");
a.traversal.transformations

unixCmd("open" + "traversals/HarmoniousHilbert2.hx".resolveRelative);


// a few other tests


b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;

b.verbose = true;
b.generateFullPath(3);
b.verbose = false;


b.generateFullPath(1);
b.generateFullPath(3);
b.findPoint([0, 2, 0, 1, 1, 1]);


// followPath

b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;

(
Tdef(\x, {
	loop {
		b.followPath({ |point, matrix, direction|
			[point, matrix, direction].postln;
			0.1.wait;
		}, 5)
	}
}).play
)



// make a map from points to indices
(
b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
~path = b.generateFullPath(4);
~coordinates = ~path.flat;
~size = ~coordinates.maxItem / 2+ 1;

~path.size;

~space = Array.fillND(~size ! b.dimension);
~path.do { |c, i| var x, y; #x, y = (c / b.scaling).asInteger;  ~space.at(x).put(y, i) };

~space.postMatrix;"";
)




b = b.as(Trip);
b.locations


c = b.fillSelf(2);
c.locations

c = c.fillSelf(2);
c.locations

