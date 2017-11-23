/*

SuperCollider implementation of the SpaceTravel system by Herman Haverkort
version 0.1

*/

Traversal {

	var <transformations, <directions, <locations;
	var <dimension;

	*new { |transformations, directions, locations|
		^super.newCopyArgs(transformations, directions, locations).standardize
	}

	initialLocation {
		^locations.first
	}

	standardize {
		var n = transformations.size;
		dimension = transformations.first.size;

		if(locations.size != n) {
			if(n - locations.size == 1) {
				locations = [0.dup(this.dimension)] ++ locations
			} {
				Error("locations and transformations should match").throw
			}
		};

		transformations.do { |x, i|
			if(x.isKindOf(Ref)) { directions[i] = -1 }
		};

	}

	size {
		^transformations.size
	}

	findPoint { |indices, origin, matrix, scale = 2|
		var ci, i, coord;
		if(indices.isEmpty) { ^nil };
		i = indices.first;
		ci = locations[i];
		origin = origin ?? { 0.dup(this.dimension) };
		if(indices.size == 1) { ^ci + origin };
		//matrix = matrix ?? { this.calcInitialMatrix(1, scale) };
		matrix = matrix ?? {this.calcInitialMatrix(1, 1) };
		matrix = transformations[i].mulMatrix(matrix);
		//[\scaled, ci.rotatePoint(matrix) / scale, \unscaled, ci].postp;
		coord = origin + (ci.rotatePoint(matrix) / scale);
		// [\coord, coord].postp;
		^this.findPoint(indices.drop(1), coord, matrix, scale)
	}

	                 // p, c, m, h, r
	generatePath { |path, origin, matrix, direction, depth, scale|
		var sd = this.dimension ** scale;
		var selector = if(direction > 0) { \do } { \reverseDo };
		if(depth <= 1) {
			path.add(origin)
		} {
			if(sd != locations.size) { "locations of wrong size (%)".format(locations.size).warn };
			if(sd != transformations.size) { "transformations of wrong size (%)".format(locations.size).warn };
			sd.perform(selector) { |i|
				var ci = locations[i];
				var tr = transformations[i];
				"origin: % location: % transformed: %%\n".postf(origin, ci, origin + ci.rotatePoint(matrix));

				this.generatePath(
					path,
					origin + ci.rotatePoint(matrix),
					tr.mulMatrix(matrix), // / scale
					direction * directions[i],
					depth - 1,
					scale
				)
			}
		}
	}

	generateFullPath { |depth, scale = 2|
		var generatePath;
		var dimension = transformations.first.size;
		var initialMatrix = this.calcInitialMatrix(depth, scale);
		var sd = this.dimension ** scale;
		var list = List.new(sd ** depth);

		this.generatePath(list, 0 ! dimension, initialMatrix, 1, depth, scale);
		list = this.shiftToGround(list);

		^list
	}

	shiftToGround { |path|
		^path - path.flop.collect(_.minItem)
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


