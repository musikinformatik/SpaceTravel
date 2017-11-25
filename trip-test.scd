



(
var drawFunc, width = 300, dur = 0.001;
var a = SpaceTravel("< [ 2 -1 } 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >");
var depth = 2;

g = drawFunc = { |reihe, width, dur, color|
	var j = 1;
	var max, min, step, scale, points;

	max = reihe.flat.maxItem;
	min = reihe.flat.minItem;
	scale = max - min;
	points = reihe.collect { |pair|
		pair = pair.linlin(min, max, 10, width - 10);
		Point(*pair)
	};

	{
		Pen.matrix = [1, 0, 0, -1, 20 , width + 20];
		Pen.strokeColor = color;
		Pen.smoothing = false;
		Pen.width = 1;
		Pen.moveTo(points[0]);
		if(dur > 0) { points.keep(j) } { points }.do { |point| Pen.lineTo(point) };

		Pen.stroke;
		j = j + 1;
	};

};


w = Window("hilbert", Rect(340, 40, width + 40, width + 40));
w.background = Color.white;
w.front;

w.drawFunc = w.drawFunc.addFunc(drawFunc.(a.traversal.generateFullPath(depth), width, dur, Color.black));
//w.drawFunc = w.drawFunc.addFunc(drawFunc.(a.traversal.generateFullPath(3), width, dur, Color.green));
//w.drawFunc = w.drawFunc.addFunc(drawFunc.(a.traversal.generateFullPath(4), width, dur, Color.red));
if(dur > 0) {
	fork({ while { w.isClosed.not } { dur.wait; w.refresh; } }, AppClock)
};

)







a = SpaceTravel.readFile("traversals/HarmoniousHilbert2.hx".resolveRelative);
a.traversal.transformations


a = SpaceTravel("< { 2 1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >");






Quarks.install("/Volumes/data/sc/quarks/SpaceTravel");

(
a = SpaceTravel.readFile("traversals/HarmoniousHilbert2.hx".resolveRelative);
//a = SpaceTravel.readFile("traversals/Gray2.hx".resolveRelative);


)



// a few othr tests


a.traversal.verbose = true;
a.traversal.generateFullPath(3);
a.traversal.locations;
a.traversal.transformations;
a.traversal.verbose = false;
a.traversal.directions;

a.traversal.generateFullPath(1);
a.traversal.generateFullPath(3);
a.traversal.findPoint([0, 2, 0, 1, 1, 1]);

a.traversal.transformations = a.traversal.transformations.rotate(-1)


~path = a.traversal.generateFullPath(3);
~coordinates = ~path.flat;
~size = ~coordinates.maxItem / 2+ 1;

~path.size;

~space = { nil ! ~size } ! ~size;
~path.do { |c, i| var x, y; #x, y = (c / 2).asInteger;  ~space.at(x).put(y, i) };

~space.postMatrix;


~space.do { |line| line.collect { |x| if(x.isNil) { " - " } { x.asString.extend(3, " ") } }.join("|").postln }

b = a.traversal.as(Trip);
b.scale = 2;
b.locations

assertEqual


c = b.fillSelf(2);

c.locations


b = b.rotateAt(2);
b.locations
b = b.rotateAt(2);
b.locations


TestArrayMatrixOps.run;

a.traversal.directions
