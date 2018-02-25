/*

SuperCollider implementation of the SpaceTravel system by Herman Haverkort
version 0.1


hello, this is Herman
*/

Traversal {

	var <>transformations, <>directions, <>locations, root;
	var <dimension, <>scaling, <direction;
	var <>verbose = false;

	*new { |transformations, directions, locations, root|
		^super.newCopyArgs(transformations, directions, locations, root)
	}

	size {
		^transformations.size
	}

	standardize { |origin = 0, argScaling = 1, argDirection = 1|
		var n = transformations.size;

		dimension = transformations.first.size;

		if(locations.size != n) {
			Error("locations and transformations should match: one location less").throw
		};

		// backward traversals are encoded as refs.
		transformations.do { |x, i|
			if(x.isKindOf(Ref)) { directions[i] = -1 }
		};

		// for 2 ** d

		scaling = argScaling / (n ** dimension.reciprocal);
		locations = locations / (n ** dimension.reciprocal);
		locations = locations.centerPath + [origin];

		direction = argDirection;

		/*
		if(direction < 0) {
			locations = locations.reverse;
			transformations = transformations.reverse;
			directions = directions.reverse;
		};
		*/

		if(verbose) {
			"\ntransformations:".postln;
			transformations.postln;
			"\ndirections:".postln;
			directions.postln;
			"\nlocations:".postln;
			locations.postln;
		};

	}


	// indexing

	wrapAt { |indices|
		^this.at(indices % this.size)
	}

	at { |indices|
		var m = this.calcInitialMatrix(1); // scaling down here.
		^if(indices.containsSeqColl) {
			indices.flop.collect { |is| // not the most efficient way, but works for now.
				this.findPoint(is, matrix: m)
			}
		} {
			this.findPoint(indices, matrix: m)
		}
	}

	findPoint { |indices, point, matrix, direction = 1|
		var ci, i;
		if(indices.isEmpty) { ^point };
		i = indices.first;
		if(i >= this.size) {
			Error("index (%) too large for given space (size: %)".format(i, this.size)).throw
		};
		if(direction < 0) { i = transformations.size - 1 - i }; // check if wrapping should be considered here
		ci = locations[i];
		if(indices.size == 1) { ^ci + point };
		matrix = matrix ?? { this.calcInitialMatrix(indices.size) };
		point = point + ci.rotatePoint(matrix);
		matrix = matrix.mulMatrix(transformations[i]) * scaling;
		^this.findPoint(indices.drop(1), point, matrix, direction)
	}

	subTraversal { |index|
		var ci, tr, dir, newLoc, newTra, newDir, baseTraversal, lastIndex;

		lastIndex = this.size - 1;

		if(index > lastIndex) {
			Error("index (%) too large for given space (size: %)".format(index, this.size)).throw
		};

		baseTraversal = if(root.isNil) { this } { root };

		if(baseTraversal.direction < 0) { index = lastIndex - index };

		ci = baseTraversal.locations[index];
		tr = baseTraversal.transformations[index];
		dir = baseTraversal.directions[index];

		newLoc = locations.collect { |point| point + ci.rotatePoint(tr) };
		newTra = transformations.collect { |matrix| matrix.mulMatrix(tr) * baseTraversal.scaling };
		newDir = directions * dir;

		^this.class.new(newTra, newDir, newLoc, root ? this).standardize(ci, 1, dir)
	}


	// path generation

	// p, c, m, h, r
	generatePath { |func, point, matrix, direction, depth|
		var selector;

		if(depth <= 0) {
			func.value(point, matrix, direction)
		} {

			selector = if(direction > 0) { \do } { \reverseDo };
			this.size.perform(selector) { |i|

				var ci = locations[i];
				var tr = transformations[i];
				var newMatrix = matrix.mulMatrix(tr) * scaling;
				var newOrigin = point + ci.rotatePoint(matrix);
				var newDirection = direction * directions[i];

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

