/*

SuperCollider implementation of the SpaceTravel system by Herman Haverkort
version 0.1



*/

Traversal {

	var <>transformations, <>directions, <>locations;
	var <>dimension, <>initialLocation, <>scaling;
	var <>verbose = false;

	*new { |transformations, directions, locations|
		^super.newCopyArgs(transformations, directions, locations).standardize
	}

	size {
		^transformations.size
	}

	standardize {
		var n = transformations.size;

		dimension = transformations.first.size;

		if(locations.size != n) {
			Error("locations and transformations should match: one location less").throw
		};

		// backward traversals are encoded as refs.
		transformations.do { |x, i|
			if(x.isKindOf(Ref)) { directions[i] = -1 }
		};

		initialLocation = 0 ! dimension;
		scaling = n ** dimension.reciprocal;

		if(verbose) {
			"\ntransformations:".postln;
			transformations.postln;
			"\ndirections:".postln;
			directions.postln;
			"\nlocations:".postln;
			locations.postln;
		};


	}

	findPoint { |indices, point, matrix|
		var ci, i;
		if(indices.isEmpty) { ^nil };
		i = indices.first;
		ci = locations[i];
		point = point ?? { 0.dup(this.dimension) };
		if(indices.size == 1) { ^ci + point };
		matrix = matrix ?? { this.calcInitialMatrix(1) };
		point = point + ci.rotatePoint(matrix);
		matrix = transformations[i].mulMatrix(matrix) / scaling;
		^this.findPoint(indices.drop(1), point, matrix)
	}


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
				var newMatrix = matrix.mulMatrix(tr) / scaling;
				var newOrigin = point + ci.rotatePoint(matrix);
				var newDirection = direction * directions[i];

				if(verbose) {
					"c: % c_i: % matrix: %\nnew matrix: % new point: %\n\n"
					.postf(point, ci, matrix.matrix2permute,
						newMatrix.matrix2permute, newOrigin);
					if(depth == 1) { "---------> %\n\n".postf(newOrigin) };
				};

				this.generatePath(func, newOrigin, newMatrix, newDirection, depth - 1)
			}
		}
	}

	followPath { |func, depth|
		var m = this.calcInitialMatrix(depth);
		var p = this.initialLocation;
		this.generatePath(func, p, m, 1, depth);
	}

	generateFullPath { |depth|

		var list = List.new(this.size * depth);
		this.followPath({ |p| list.add(p) }, depth);
		list = list.floorPath;

		^list
	}

	calcInitialMatrix { |depth|
		var n = this.dimension;
		^{ |i|
			{ |j|
				if(i == j) { this.scaling ** depth } { 0 }
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


}

