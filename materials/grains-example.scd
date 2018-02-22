



(
SynthDef(\x, { |out, sustain, freq, amp = 0.1, pan|
	var env, sig;

	env = EnvGen.ar(Env.perc(0.1, 0.9), timeScale:sustain, doneAction:2);
	//env = EnvGen.ar(Env.perc(0.9, 0.1), timeScale:sustain, doneAction:2);
	//env = EnvGen.ar(Env.sine(1), timeScale:sustain, doneAction:2);
	sig = SinOsc.ar(freq, 0.5pi);
	amp = AmpCompA.kr(freq) * amp;

	sig = Pan2.ar(sig, pan, amp * env);

	OffsetOut.ar(out, sig)
}).add
)


(instrument:\x, freq: 1889, sustain: 0.2).play;




(
Tdef(\z, {
	inf.do {
		(instrument:\x, freq: 1889 + rrand(200.0, 500.0), sustain: 0.2).play;
		0.1.wait;
	}

}).play
)


(
Tdef(\z, {
	inf.do {
		(instrument:\x, freq: 560 + rrand(20.0, 5000.0), sustain: 0.02).play;
		0.01.wait;
	}

}).play
)



(
Tdef(\z, {
	inf.do {
		(instrument:\x, freq: 700 * { rrand(1, 4.5) }.dup(3), sustain: 0.01).play;
		0.01.wait;
	}

}).play
)




(
Tdef(\z, {
	inf.do { |i|
		(instrument:\x, freq: 700 * (i + 1 * 0.01 % 4), sustain: 0.01).play;
		0.01.wait;
	}

}).play
)


b = { rrand(0, 1.0) } ! 10;
a = { { { (1..7).choose / 7 }.dup(16) }.dup(16) }.dup(16);
a = { { { b.choose }.dup(16) }.dup(16) }.dup(16);
(
Tdef(\z, {
	var x = a[0];
	inf.do { |i|
		(instrument:\x, freq: 200 * (1 + a.wrapAt(i) * 4), sustain: 0.1).play;
		0.1.wait;
	}

}).play
)


(
Tdef(\z, {
	a.do { |x|
		x.do { |y|
			(instrument:\x, freq: 100 * (1 + y * 8), sustain: 0.3 / (y + 1)).play;
			0.1.wait;
		};
		1.wait;
	}

}).play
)



// many paralell voices


s.options.maxNodes = 12000;
s.reboot;

(
fork {
	2000.do {
		(instrument:\x, freq: 1889 + 1000.0.rand2, sustain: 3.2, amp: 0.006).play;
		0.01.wait;
	};
}
)








