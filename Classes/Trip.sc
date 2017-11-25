
Trip : Traversal {

	var <>scale;


	*newFrom { |traversal|
		^super.new(traversal.transformations, traversal.directions, traversal.locations)
	}

	rotatedTransformationsAt { |index|
		var tr = transformations[index];
		^transformations.collect { |x, i| tr.mulMatrix(x) / scale }
	}

	rotatedDirectionsAt { |index|
		var h = directions[index];
		^directions.collect { |x, i| h * x }
	}
	rotatedLocationsAt { |index|
		var tr = transformations[index];
		var c = locations[index];
		^locations.collect { |x, i| c + x.rotatePoint(tr) }
	}

	rotateAt { |index|
		if(index >= transformations.size) { Error("No point to be found at index (%)".format(index)).throw };

		^this.class.new(
			this.rotatedTransformationsAt(index),
			this.rotatedDirectionsAt(index),
			this.rotatedLocationsAt(index)
		).scale_(scale)
	}

	++ { |traversal|
		^this.class.new(
			transformations ++ traversal.transformations,
			directions ++ traversal.directions,
			locations ++ traversal.locations
		)
	}

	fillSelf { |depth = 1|
		^if(depth < 1) {
			this
		} {
			this.size.collect { |i|
				this.rotateAt(i).fillSelf(depth - 1)
			}.reduce('++')
		}
	}

}


