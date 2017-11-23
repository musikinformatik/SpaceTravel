+ SequenceableCollection {

	// matrix multiplication
	mulMatrix { |other|
		if(this.first.size != other.size) {
			Error("matrices are incompatible:\n\n%\n\n%\n\n%".format(this, other)).throw
		};
		^this.collect { |row| (row * other).sum }
	}

	rotatePoint { |matrix|
		^(this * matrix).sum
	}

	// function: converting from a permutation form to a matrix
	permute2matrix {
		var n = this.size;
		^this.collect { |val|
			(1..n).collect { |i| if(i == val.abs) { val.sign } { 0 } }
		}
	}

	// function: inverse conversion
	matrix2permute { |m|
		^this.collect { |row|
			var index = row.detectIndex { |a| a != 0 };
			if(index.isNil) { Error("incorrect format").throw };
			index + 1 * (row[index].sign)
		}
	}

	matrix2string {
		var shape = this.shape;
		^switch(shape.size,
			1, { this.join(" | ") },
			2, { this.collect(_.join(" | ")).join(\n) },
			{ "[\n" ++ this.collect { |row| row.asCompileString } << "\n]" }
		)
	}

	// function: generating path from a movement, starting at point p
	collectMoves { |moves, origin, scaleFactor = 1|
		var p = origin;
		^moves.collect { |move|
			p = p.copy;
			move.asArray.do { |each|
				var i = each.abs - 1;
				p[i] = p[i] + (scaleFactor.value * each.sign)
			};
			p
		}
	}





}