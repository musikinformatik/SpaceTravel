
// to run the example, first install SpaceTravel
Quarks.install("/Volumes/data/sc/quarks/SpaceTravel");

//
Quarks.install("https://github.com/musikinformatik/SpaceTravel");


(
p = { |travel, depth, dur = 0, width = 340|
	var path = travel.traversal.generateFullPath(depth);
	k = SpaceTravelImage(travel.name ? "plan",  Rect(340, 40, width, width));
	k.addPath(path, dur, Color.black);
};
)

// post all traversal names
pathMatch("traversals/*".resolveRelative).collect { |x| x.basename.postln }; "";

// open the directory
unixCmd("open" + "traversals/HarmoniousHilbert2.hx".resolveRelative);



SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal.generateFullPath(3).cs

// some drawings
p.(SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >"), 2, 0.1);


p.(SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >"), 6, 0.01);


p.(SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >"), 6);
p.(SpaceTravel.readFile("traversals/BaseCamp2.hx".resolveRelative), 4, 0.01);
p.(SpaceTravel.readFile("traversals/HarmoniousHilbert2.hx".resolveRelative), 4);
p.(SpaceTravel.readFile("traversals/DoubleGray2.hx".resolveRelative), 4, 0.01);
p.(SpaceTravel.readFile("traversals/DoubleGray2.hx".resolveRelative), 4);
p.(SpaceTravel.readFile("traversals/Peano2.hx".resolveRelative), 3, 0.01);
p.(SpaceTravel.readFile("traversals/InsideOut2.hx".resolveRelative), 5, 0);

p.(SpaceTravel.readFile("traversals/Z2.hx".resolveRelative), 5, 0.1);




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



// arbitrary path
a = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { -1 2 ] 1 { 1 -2 ] -2 [ -2 -1 } >")
a.traversal.generateFullPath(2);

p.(a, 1);
p.(a, 2);
p.(a, 3);
p.(a, 6);



b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
b.at([0, 1, 0]);


b.at([0, 2, 0, 1, 1, 1]);
b.at([0, 2, 0, 1, 1, 10]); // should throw an error

b.wrapAt([0, 2, 0, 1, 1, 10]);

b.wrapAt([0, 2, (0..3), 1, 1, 1]);

// benchmarking
i = { rrand(0, 6) } ! 10;
bench { 100.do { b.wrapAt(i) } };
i = { rrand(0, 6) } ! 3;
bench { 100.do { b.wrapAt(i) } };



z.("random parts", { b.findPoint() }.dup(200));
(
z.("random parts", {
	var c0 = { b.size.rand }.dup(rrand(1, 8));
	{
		c0[c0.lastIndex] = c0[c0.lastIndex] + 1;
		b.findPoint(c0);
	}.dup(30);
}.dup(2).flatten(1));
)



// a few other tests


b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;

b.verbose = true;
b.generateFullPath(3);
b.verbose = false;


b.generateFullPath(1);
b.generateFullPath(3);




b = SpaceTravel.readFile("traversals/Peano2.hx".resolveRelative).traversal;

p = b.generateFullPath(4);
p.size

p[300..600]



/*

Three dimensional traversal Peano 3

*/


b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;

b = SpaceTravel.readFile("traversals/Peano3.hx".resolveRelative).traversal;

p = b.generateFullPath(3); // wait a little.


// how to get max and min?
[p[0][0], p[1][0], p[2][0]]

p.collect { |each| each[0] }
p.collect { |each| each[1] }
p.collect { |each| each[2] } // nilnilnil
p.flop[0]

p.flat
p.flat.maxItem
p.flat.minItem



(
SynthDef(\x, { |out, freq, sustain, amp = 0.1|

	var env, son, trig;
	env = EnvGen.ar(Env.sine(sustain, amp * 10 * AmpComp.kr(freq, 100, 0.3)), doneAction:2);
	trig = LPF.ar(Impulse.ar(0), freq) * PinkNoise.ar(0.1, 1);
	son = Klank.ar(`[[1, 1.25, 1.5], [1], [sustain]], freqscale: freq, input: trig);
	OffsetOut.ar(out, son * env);

}).add;
)


(
var max, min;
max = p.flat.maxItem;
min = p.flat.minItem;
Tdef(\x, {

	p.do { |point|
		var freq;
		freq = point.linlin(min, max, 500, 9000);
		//[point, matrix, direction].postln;
		(
			instrument: \x,
			freq: freq,
			out: [0, 1, 2], // [0, 1, 1] // at home
			sustain: 0.01
		).play;
		0.01.wait;
	}
}).play;
)
)


TempoClock.default.tempo = 4;


(
SynthDef(\x, { |out, freq, sustain, amp = 0.1|

	var env, son, trig;
	freq = freq.expexp(500, 9000, 9000, 500);
	env = EnvGen.ar(Env.sine(sustain, amp * 10 * AmpComp.kr(freq, 100, 0.3)), doneAction:2);
	trig = LPF.ar(Impulse.ar(0), freq) * PinkNoise.ar(0.1, 1);
	son = Klank.ar(`[[1, 1.25, 1.5], [1], [sustain]], freqscale: freq, input: trig);
	OffsetOut.ar(out, son * env);

}).add;
)



(
SynthDef(\x, { |out, freq, sustain, amp = 0.1|

	var env, son, trig, f0;
	f0 = freq.explin(500, 9000, 0, 1);
	f0 = f0 * (2 ** MouseX.kr(1, 18, 1).round(1).lag(1)) % 1;
//	f0 = IEnvGen.kr(Env([0, 1, 0], 1/2), f0 * (2 ** 1) % 1);
	freq = f0.linexp(0, 1, 100, 10000);
	env = EnvGen.ar(Env.sine(sustain, amp * 10 * AmpComp.kr(freq, 100, 0.3)), doneAction:2);
	trig = LPF.ar(Impulse.ar(0), freq) * PinkNoise.ar(0.1, 1);
	//son = Klank.ar(`[[1, 1.25, 1.5], [1], [sustain]], freqscale: freq, input: trig);
	son = FSinOsc.ar(freq) * 0.03;
	OffsetOut.ar(out, son * env);

}).add;
)



(
SynthDef(\x, { |out, freq, sustain, amp = 0.1|

	var env, son, trig, f0;
	f0 = freq.explin(500, 9000, 0, 1);
	f0 = f0 * (2 ** MouseX.kr(1, 18, 1).round(1).lag(1)) % 1;
//	f0 = IEnvGen.kr(Env([0, 1, 0], 1/2), f0 * (2 ** 1) % 1);
	freq = MouseY.kr(1, 5) ** f0 * 440; //f0.linexp(0, 1, 100, 10000);
	env = EnvGen.ar(Env.sine(sustain, amp * 10 * AmpComp.kr(freq, 100, 0.3)), doneAction:2);
	trig = LPF.ar(Impulse.ar(0), freq) * PinkNoise.ar(0.1, 1);
	//son = Klank.ar(`[[1, 1.25, 1.5], [1], [sustain]], freqscale: freq, input: trig);
	son = FSinOsc.ar(freq) * 0.03;
	OffsetOut.ar(out, son * env);

}).add;
)




p.size * 0.01 / 60


p.size / (3 ** 3) / (3 ** 3)  / (3 ** 3)  / (3 ** 3)
(3 ** 3) ** 4

(3 ** 3) ** n

p[0].size
b.scaling

(
~dropNth = { |p, depth, scaling = 3|
	var dim = p[0].size;
	var n = scaling ** dim ** depth;
	p.select { |x, i| i % n == 0 }
};
)

~dropNth.(p, 0).size

(
Tdef(\x, {
	~dropNth.(p, 2).do { |point|
		var freq;
		freq = point.linlin(0, 240, 500, 9000);
		(
			instrument: \x,
			freq: freq,
			out: [0, 1, 2], // [0, 1, 1] // at home
			sustain: 0.01
		).play;
		0.1.wait;
	}
}).play;
)
)









(instrument:\x, freq:600, sustain: 3).play;


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
		var note = point.fold(-20, 20) + 30;
		(instrument: \x, note: note, out: [0, 1], sustain: 0.2).play;
		0.1.wait;
	}, 4);

}).play;


Tdef(\y, {
	2.do {
		b.followPath({ |point, matrix, direction|
			var note = point.fold(-20, 20) + 30 - 12;
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


// 2-space

b = SpaceTravel("< { 2 -1 ] 1 [ 1 2 } 2 { 1 -2 ] -1 [ -2 -1 } >").traversal;
b.fillSpace(4, { |c, i| i }).postMatrix;""
b.fillSpace(5, { |c, i| i }).postMatrix;""



b.fillSpace(2, { |...args| args.postln })
b.generateFullPath(2)


(
b.fillSpace(4, { |c, i| i }).postMatrix;
x = b.fillSpace(4, { |point, index, matrix, direction|
	(
		index: index,
		matrix:matrix,
		direction:direction,
		point: point
	)
})
)

[1]

x.collect { |y| y.collect { |e| e[\point] } }.postMatrix

(
Tdef(\x, {
	x.do { |y, i|
		y.do { |e|
			var freq  = e[\index].linexp(0, 255, 120, 10000);
			(
				instrument: \x,
				freq: freq,
				out: i,
				sustain: 0.03
			).play;
			0.1.wait;
		};
		1.wait;
	}

}).play
)






// 4-space

b = SpaceTravel.readFile("traversals/DoubleGray4.hx".resolveRelative).traversal;
b.fillSpace(2, { |c, i| i });
x = b.fillSpace(3, { |c, i| i }); // higher than 3 will take lots of time.


(
x = b.fillSpace(3, { |point, index, matrix, direction|
	(
		index: index,
		matrix:matrix,
		direction:direction,
		point: point
	)
})
)


x.slice(3, 4, 5, 1)
x.deepAt([3, 4, 5, 1])

bench { 100.do { x.slice(3, 4, 5, 1) } }
bench { 100.do { x.deepAt([3, 4, 5, 1]) } }



[[1, 2, 3]].deepPut([0, 1], 99);
[[1, 2, 3]].deepAt([0, 1]);

Array.fillND(2 ! 3);




// trip


b = b.as(Trip);
b.locations


c = b.fillSelf(2);
c.locations

// more instances is very inefficient

(
a =  [
	[-1,  1,  4],
	[ 6, -4,  2],
	[-3,  5,  0],
	[ 3,  7, -2]
];

b = [
	[-1,  1,  4,  8],
	[ 6,  9, 10,  2],
	[11, -4,  5, -3]
];

c =  [
	[51, -8, 26, -18],
	[-8, -38, -6, 34],
	[33, 42, 38, -14],
	[17, 74, 72, 44]
];

(a *.x b.flop).collect(_.sum).clump(a.size)
)



// running the unit tests
TestArrayMatrixOps.run;

(a *.x b).clump(a.size).sum


mmult :: Num a => [[a]] -> [[a]] -> [[a]]
mmult a b = [ [ sum $ zipWith (*) ar bc | bc <- (transpose b) ] | ar <- a ]


all {: sum(x * y), x<-a, y<-b.flop }.clump(a.size)

point.sum { |x| x * m }.clump(m.size)

[
	[0, 10]
	[2, 3]
	[7, 8]
]

