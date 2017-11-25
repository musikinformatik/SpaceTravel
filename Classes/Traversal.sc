/*

SuperCollider implementation of the SpaceTravel system by Herman Haverkort
version 0.1



*/

Traversal {

	var <>transformations, <>directions, <>locations;
	var <>dimension, <>initialLocation;
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
			if(n - locations.size == 1) {
				locations = [0.dup(this.dimension)] ++ locations
			} {
				Error("locations and transformations should match: one location less").throw
			}
		};

		// backward traversals are encoded as refs.
		transformations.do { |x, i|
			if(x.isKindOf(Ref)) { directions[i] = -1 }
		};

		initialLocation = 0 ! dimension;

		if(verbose) {
			"\ntransformations:".postln;
			transformations.postln;
			"\ndirections:".postln;
			directions.postln;
			"\nlocations:".postln;
			locations.postln;
		};


	}

	findPoint { |indices, point, matrix, scale = 2|
		var ci, i;
		if(indices.isEmpty) { ^nil };
		i = indices.first;
		ci = locations[i];
		point = point ?? { 0.dup(this.dimension) };
		if(indices.size == 1) { ^ci + point };
		matrix = matrix ?? { this.calcInitialMatrix(1, scale) };
		point = point + ci.rotatePoint(matrix);
		matrix = transformations[i].mulMatrix(matrix) / scale;
		^this.findPoint(indices.drop(1), point, matrix, scale)
	}

	// p, c, m, h, r
	generatePath { |func, point, matrix, direction, depth, scale|
		var selector;
		var sd = this.dimension ** scale;

		if(depth <= 0) {
			func.value(point, matrix, direction)
		} {
			if(sd != locations.size) { "locations of wrong size (%)".format(locations.size).warn };
			if(sd != transformations.size) { "transformations of wrong size (%)".format(locations.size).warn };

			selector = if(direction > 0) { \do } { \reverseDo };
			sd.perform(selector) { |i|

				var ci = locations[i];
				var tr = transformations[i];
				var newMatrix = tr.mulMatrix(matrix) / scale;
				var newOrigin = point + ci.rotatePoint(matrix);
				var newDirection = direction * directions[i];

				if(verbose) {
					"c: % c_i: % matrix: %\nnew matrix: % new point: %\n\n"
					.postf(point, ci, matrix.matrix2permute,
						newMatrix.matrix2permute, newOrigin);
					if(depth == 1) { "---------> %\n\n".postf(newOrigin) };
				};

				this.generatePath(func, newOrigin, newMatrix, newDirection, depth - 1, scale)
			}
		}
	}

	followPath { |func, depth, scale = 2|
		var m = this.calcInitialMatrix(depth, scale);
		var p = this.initialLocation;
		this.generatePath(func, p, m, 1, depth, scale);
	}

	generateFullPath { |depth, scale = 2|

		var sd = dimension ** scale;
		var list = List.new(sd ** depth);
		this.followPath({ |p| list.add(p) }, depth, scale);
		list = list.floorPath;

		^list
	}



	calcInitialMatrix { |depth, scale|
		var n = this.dimension;
		^{ |i|
			{ |j|
				if(i == j) { scale ** depth } { 0 }
			}.dup(n)
		}.dup(n)
	}


}
	