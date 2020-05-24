/*

SuperCollider implementation of the SpaceTravel system by Herman Haverkort
version 0.1


hello, this is Herman
*/

Traversal {

	var <>transformations, <>directions, <>locations;
	var <>t0, <>d0, <>l0;

	var <dimension, <scaling;
	var <>verbose = false;

	*new { |transformations, directions, locations, t0, d0, l0|
		^super.newCopyArgs(transformations, directions, locations, t0, d0, l0).init
	}

	size {
		^transformations.size
	}

	init {

		dimension = transformations.first.size;

		if(locations.size != this.size) {
			Error("locations and transformations should match: one location less").throw
		};
		// backward traversals are encoded as refs.
		transformations.do { |x, i|
			if(x.isKindOf(Ref)) { directions[i] = -1 }
		};

			// for 2 ** d

		scaling = 1 / (this.size ** dimension.reciprocal);

		if(verbose) {
			"\ntransformations:".postln;
			transformations.postln;
			"\ndirections:".postln;
			directions.postln;
			"\nlocations:".postln;
			locations.postln;
		};

	}

	standardize {

		locations = locations.centerPath;




		t0 = t0 ?? { this.calcInitialMatrix(1) };
		d0 = d0 ? 1;
		l0 = l0 ?? { 0 ! dimension };

	}


	// indexing

	wrapAt { |indices|
		^this.at(indices % this.size)
	}

	at { |indices|
		^if(indices.containsSeqColl) {
			indices.flop.collect { |is| // not the most efficient way, but works for now.
				this.findPoint(is)
			}
		} {
			this.findPoint(indices)
		}
	}

	findPoint { |indices, point, matrix, direction|
		var ci, i;

		point = point ? l0;
		matrix = matrix ? t0;
		direction = direction ? d0;

		if(indices.isEmpty) { ^point };
		i = indices.first;
		if(i >= this.size) {
			Error("index (%) too large for given space (size: %)".format(i, this.size)).throw
		};
		if(direction < 0) { i = transformations.lastIndex - i }; // check if wrapping should be considered here
		ci = locations[i];
		if(indices.size == 1) { ^ci + point };
		point = point + ci.rotatePoint(matrix);
		matrix = matrix.mulMatrix(transformations[i]) * scaling;
		^this.findPoint(indices.drop(1), point, matrix, direction)
	}

	subTraversal { |index|
		var ci, tr, di, newMatrix, newDirection, newOrigin, lastIndex;

		lastIndex = this.size - 1;

		if(index > lastIndex) {
			Error("index (%) too large for given space (size: %)".format(index, this.size)).throw
		};

		if(d0 < 0) { index = lastIndex - index };

		ci = locations[index];
		tr = transformations[index];
		di = directions[index];

		newMatrix = t0.mulMatrix(tr) * scaling;
		newDirection = d0 * di;
		newOrigin = l0 + ci.rotatePoint(t0);

		// once this works, we can just make an object that has pnly the last three,
		// and the traversal as instance variables

		^this.class.new(transformations, directions, locations, newMatrix, newDirection, newOrigin)
	}


	// path generation

	// p, c, m, h, r
	generatePath { |func, point, matrix, direction, depth|
		var selector;


		point = point ? l0;
		matrix = matrix ? t0;
		direction = direction ? d0;


		if(depth <= 0) {
			func.value(point, matrix, direction)
		} {

			selector = if(direction > 0) { \do } { \reverseDo };
			this.size.perform(selector) { |index|

				var ci = locations[index];
				var tr = transformations[index];
				var di = directions[index];

				var newMatrix = matrix.mulMatrix(tr) * scaling;
				var newDirection = direction * di;
				var newOrigin = point + ci.rotatePoint(matrix);

				if(verbose) {
					"c: % c_i: % matrix: %\nnew matrix: % new point: % direction: % -> %\n\n"
					.postf(point, ci, matrix.matrix2permute,
						newMatrix.matrix2permute, newOrigin, direction, newDirection);
					if(depth == 1) { "---------> %\n\n".postf(newOrigin) };
				};

				this.generatePath(func, newOrigin, newMatrix, newDirection, depth - 1)
			}
		}
	}


	generateFullPath { |depth|

		var list = List.new(this.size * depth);
		this.followPath({ |p| list.add(p) }, depth);
		list = list.floorPath;

		^list
	}

	followPath { |func, depth, origin = 0|
		var m = this.calcInitialMatrix(depth);
		this.generatePath(func, origin, m, 1, depth);
	}


	fillSpace { |depth, func|
		var space = Array.fillND((scaling ** depth) ! this.dimension);
		var mul = scaling;
		var n = this.size * depth;

		var coords = List.new(n);
		var values = List.new(n);
		this.followPath({ |point, matrix, direction|
			coords.add(point);
			values.add([matrix, direction]);

		}, depth);

		coords.floorPath.do { |c, i|
			var v = values[i];
			var point = (c * mul).asInteger;
			var w = func.valueArray(point, i, v);
			space.deepPut(point, w)
		};

		^space
	}


	calcInitialMatrix { |depth|
		var n = this.dimension;
		^{ |i|
			{ |j|
				if(i == j) { this.scaling.reciprocal ** depth } { 0 }
			}.dup(n)
		}.dup(n)
	}

	printOn { |stream|
		stream << this.class.name << "(";
		transformations.do { |tr, i|
			var d = directions[i];
			stream << if(d > 0) { $[ } { ${ };
			tr.matrix2permute.do(stream << _);
			stream << if(d > 0) { $} } { $] };
		};
		stream << ")";
	}

	storeOn { |stream|
		stream << "\n";
		stream << this.class.name;
		stream << "(";
		stream <<< transformations;
		stream << ",\n";
		stream <<< directions;
		stream << ",\n";
		stream <<< locations;
		stream << "\n)";
	}


	plotPointPath {
		^this.locations.plotPointPath
	}

}

