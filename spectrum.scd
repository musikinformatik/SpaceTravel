

// post all traversal names
pathMatch("traversals/*".resolveRelative).collect { |x| x.basename.postln }; "";


a = SpaceTravel.readFile("traversals/InsideOut2.hx".resolveRelative).traversal;
b = SpaceTravel.readFile("traversals/Z2.hx".resolveRelative).traversal;


x = a.generateFullPath(7);
y = b.generateFullPath(7);

[1, 4, 2, 3, 4].differentiate.drop(1)

f = { |x| x.differentiate.drop(1).abs.collect { |x| x.squared.sum.sqrt } };
g = { |x| x.as(Bag) };

k = g.(f.(x));
l = g.(f.(y));

(
var depth = 7;
a.scaling ** depth * 2 * sqrt(a.dimension)
)


(
var spectrum;
var depth = 7;
var maxPossibleJump = a.scaling ** depth * 2 * sqrt(a.dimension);
l.countsDo { |item, count|
	var freq, amp;
	freq = 2 ** item.linlin(2, maxPossibleJump, 0, 3);
	amp = count.expexp(1, l.size, 0.1, 1);
	spectrum = spectrum.add([freq, amp]);
};
~spectrum = spectrum;
)

(
Ndef(\x, {
	var imp, freq, amp;
	imp = Dust.ar(2).lag(0.001);
	freq = ~spectrum.collect { |x| x[0] };
	amp = ~spectrum.collect { |x| x[1] };

	Klank.ar(`[freq * 300, amp], imp)
	*
	0.1

}).play
)



(
var spectrum;
var depth = 7;
var maxPossibleJump = a.scaling ** depth * 2 * sqrt(a.dimension);
k.countsDo { |item, count|
	var freq, amp;
	freq = 2 ** item.linlin(2, maxPossibleJump, 0, 3);
	amp = count.expexp(1, l.size, 0.1, 1);
	spectrum = spectrum.add([freq, amp]);
};
~spectrum2 = spectrum;
)

(
Ndef(\y, {
	var imp, freq, amp;
	imp = Dust.ar(2).lag(0.001);
	freq = ~spectrum2.collect { |x| x[0] };
	amp = ~spectrum2.collect { |x| x[1] };

	Klank.ar(`[freq * 300, amp], imp)
	*
	0.1

}).play(4);
)

f.(x).separate { |a, b| a != b }.collect(_.size)
