
// to run the example, first install SpaceTravel
Quarks.install("/Volumes/data/sc/quarks/SpaceTravel");


// two useful functions for display
(
g = { |w, reihe, dur, color|
	var j = 1;
	var max, min, step, scale, points, zoomPoint;
	var width = w.view.bounds.width * 0.9;
	var downPoint = Point(1, 1) * width / 2, downZoom = 0, zoom = 0;

	max = reihe.flat.maxItem;
	min = reihe.flat.minItem;
	scale = max - min;
	points = reihe.collect { |pair|
		pair = pair.linlin(min, max, 10, width - 10);
		//pair = 180 - pair + min * 2;
		Point(*pair)
	};

	zoomPoint = { |point|
		var dist = point - downPoint;
		point + (zoom * dist);
	};

	w.drawFunc = w.drawFunc.addFunc({
		var p;
		Pen.matrix = [1, 0, 0, -1, 20 , width + 20];
		Pen.strokeColor = color;
		Pen.smoothing = false;
		Pen.width = 1;
		Pen.moveTo(zoomPoint.(points.first));
		p = if(dur > 0) { points.keep(j) } { points };

		p.do { |point| Pen.lineTo(zoomPoint.(point)) };

		Pen.stroke;
		j = j + 1;
	});

	w.view.mouseDownAction = { |v, x, y|
		downPoint = Point(x, y);
	};

	w.view.mouseMoveAction = { |v, x, y|
		var dist;
		if(downPoint.notNil) {
			dist = y - downPoint.y;
			zoom = downZoom + 1 * (dist  / 500);
			w.refresh;
		}
	};
	w.view.mouseUpAction = { |v, x, y|
		downZoom = zoom;
	};

};

p = { |travel, depth, dur = 0, width = 340|
	var w = Window(travel.name ? "path", Rect(340, 40, 340, 340));
	w.background = Color.white;
	w.front;

	g.(w, travel.traversal.generateFullPath(depth), dur, Color.black);
	if(dur > 0) {
		fork({ while { w.isClosed.not } { dur.wait; w.refresh } }, AppClock)
	};
};
)


// post all traversal names
pathMatch("traversals/*".resolveRelative).collect { |x| x.basename.postln }; "";

// open the directory
unixCmd("open" + "traversals/HarmoniousHilbert2.hx".resolveRelative);


// some drawings
p.(SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >"), 3);
p.(SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >"), 6);
p.(SpaceTravel.readFile("traversals/BaseCamp2.hx".resolveRelative), 4, 0.01);
p.(SpaceTravel.readFile("traversals/HarmoniousHilbert2.hx".resolveRelative), 4);
p.(SpaceTravel.readFile("traversals/DoubleGray2.hx".resolveRelative), 4);
p.(SpaceTravel.readFile("traversals/DoubleGray2.hx".resolveRelative), 4);
p.(SpaceTravel.readFile("traversals/Peano2.hx".resolveRelative), 3, 0.01);
p.(SpaceTravel.readFile("traversals/InsideOut2.hx".resolveRelative), 5, 0);





a = SpaceTravel.readFile("traversals/BaseCamp2.hx".resolveRelative);
a.traversal


a.traversal.transformations
a.traversal.directions
a.traversal.locations


// some inspections
a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >");
a.traversal
a.traversal.transformations
a.traversal.directions
a.traversal.locations


// conversions
[2, -1].permute2matrix


(
[
	[ 0, 0, -1 ],
	[ 1, 0, 0 ],
	[ 0, 1, 0 ]
].matrix2permute
)

[2,3,-1].permute2matrix.matrix2permute


// running the unit tests
TestArrayMatrixOps.run;


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
SynthDef(\x, { |out, freq, sustain, amp = 0.1|

	var env, son, trig;
	env = EnvGen.ar(Env.perc(0.01, sustain, amp), doneAction:2);
	trig = LPF.ar(Impulse.ar(0), freq) * PinkNoise.ar(0.1, 1);
	son = Klank.ar(`[[1, 1.25, 1.5], [1], [sustain]], freqscale: freq, input: trig);
	OffsetOut.ar(out, son * env);

}).add;

Tdef(\x, {
	b.followPath({ |point, matrix, direction|
		var note = point + 30;
		(instrument: \x, note: note, out: [0, 1], sustain: 0.2).play;
		0.1.wait;
	}, 4);

}).play;


Tdef(\y, {
	2.do {
		b.followPath({ |point, matrix, direction|
			var note = point + 30 - 12;
			(instrument: \x, note: note, out: [0, 1], sustain: 2.2).play;
			(0.1 * (b.scaling ** 2 * 2)).wait;
		}, 2);
	};
}).play
)


(
Tdef(\x, {
	b.followPath({ |point, matrix, direction|
		var freq = point.abs.linexp(-0, 200, 300, 8000);
		(instrument: \x, sustain: 0.03, freq: freq, out: [0, 1]).play;
		//[point, matrix, direction].postln;
		0.01.wait;
	}, 7)

}).play
)


// make a map from points to indices
(
b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
~path = b.generateFullPath(4);
~coordinates = ~path.flat;
~size = ~coordinates.maxItem / 2 + 1;

~path.size;

~space = Array.fillND(~size ! b.dimension);
~path.do { |c, i| var x, y; #x, y = (c / b.scaling).asInteger;  ~space.at(x).put(y, i) };

~space.postMatrix;"";

~project = { |x, y| ~path @ (~space @@ x @@ y) };
)

~project.(34, 125);





// trip


b = b.as(Trip);
b.locations


c = b.fillSelf(2);
c.locations

// more instances is very inefficient



