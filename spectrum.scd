
/*

A first attempt at sonifying higher level properties of traversals.

What follows allows to compare the jump sizes of traversals

*/





// some preliminary tests

// post all traversal names
pathMatch("traversals/*".resolveRelative).collect { |x| x.basename.postln }; "";


a = SpaceTravel.readFile("traversals/InsideOut2.hx".resolveRelative).traversal;
b = SpaceTravel.readFile("traversals/Z2.hx".resolveRelative).traversal;


x = a.generateFullPath(7);
y = b.generateFullPath(7);

[1, 4, 2, 3, 4].differentiate.drop(1)

f = { |x| x.differentiate.drop(1).abs.collect { |x| x.squared.sum.sqrt } };
g = { |x| x.as(Bag) };

f.(x).separate { |a, b| a != b }.collect(_.size)

k = g.(f.(x));
l = g.(f.(y));


(
var depth = 7;
a.scaling ** depth * 2 * sqrt(a.dimension)
)


////////////////////////////////////////////
// sonifying jump sizes

(
~collectJumpSizes = { |x|
	x.differentiate.drop(1).abs.collect { |x| x.squared.sum.sqrt }
};

// pairs of ratio between 1 and 2, and amplitude
~generateSpectrum = { |traversal, depth = 7|
	var path = traversal.generateFullPath(depth);
	var sizes = ~collectJumpSizes.(path);
	var spectrum;
	var maxPossibleJump = traversal.scaling ** depth * 2 * sqrt(traversal.dimension);
	var l = sizes.as(Bag);
	l.countsDo { |item, count|
		var freq, amp;
		freq = 2 ** item.linlin(2, maxPossibleJump, 0, 3);
		amp = count.expexp(1, l.size, 0.1, 1);
		spectrum = spectrum.add([freq, amp]);
	};
	spectrum
};
)

~spectrum = ~generateSpectrum.(SpaceTravel.readFile("traversals/InsideOut2.hx".resolveRelative).traversal, 7);
~spectrum2 = ~generateSpectrum.(SpaceTravel.readFile("traversals/Z2.hx".resolveRelative).traversal, 7);


// compare the two:

// insideout
(
Ndef(\x, {
	var imp, freq, amp;
	imp = Dust.ar(2).lag(0.001);
	freq = ~spectrum.collect { |x| x[0] };
	amp = ~spectrum.collect { |x| x[1] };

	Klank.ar(`[freq * 800, amp, 3], imp)
	*
	0.1

}).play
)

// Z2
(
Ndef(\x, {
	var imp, freq, amp;
	imp = Dust.ar(2).lag(0.001);
	freq = ~spectrum2.collect { |x| x[0] };
	amp = ~spectrum2.collect { |x| x[1] };

	Klank.ar(`[freq * 800, amp, 3], imp)
	*
	0.1

}).play;
)

