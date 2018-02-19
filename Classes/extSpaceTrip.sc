+ SequenceableCollection {

	// matrix multiplication

	mulMatrix { |other|

		var size = this.size;
		var out = Array.fill(size, { Array.new(size) });
		var transposed = other.flop;

		/*
		if(this.first.size != other.size) {
			Error("matrices are incompatible:\n\n%\n\n%\n\n%".format(this, other)).throw
		};
		*/

		this.do { | row, i |
			size.do { | j |
				var c = transposed[j];
				if(c.notNil) {
					out[i].add(sum(row * c))
				}
			};
		};

		^out
	}

	applyMatrixToPoint { |point|

		var size = this.size;
		var out = Array.new(size);
		var transposed = [point];


		this.do { | row, i |
			size.do { | j |
				var c = transposed[j];
				if(c.notNil) {
					out.add(sum(row * c))
				}
			};
		};

		^out
	}

	rotatePoint { |matrix|
		^matrix.applyMatrixToPoint(this)  // "this" is the point
	}

	/*
	rotatePoint2 { |matrix|
		var rowVector = matrix.size.collect { |i| [this[i]] };
		var rotated = matrix.mulMatrix(rowVector);
		^rotated.collect { |x| x[0] }
	}
	*/

	transposeMatrix {
		^if(this[0].isSequenceableCollection) {
			this.flop
		} {
			this.bubble.flop
		}
	}

	// deepAt works like slice for single indices, so it is much more efficient

	deepAt { |indices|
		var res = this;
		indices.do { |i|
			res = res[i]
		};
		^res
	}

	deepPut { |indices, value|
		var res = this;
		indices.drop(-1).do { |i|
			res = res[i]
		};
		^res.put(indices.last, value)
	}

	// converting from a permutation form to a matrix
	permute2matrix {
		var n = this.size;
		^(1..n).collect { |i|
			this.collect { |val| if(i == val.abs) { val.sign } { 0 } }
		}
	}

	// converting from a matrix to a permutation
	matrix2permute {
		^this.flop.collect { |row, j|
			var index = row.detectIndex { |a| a != 0 };
			if(index.isNil) {
				Error(
					"conversion to permutation formt: "
					"matrix has incorrect format (only zero entries in row %):\n%".format(j, this)).throw
			};
			(index + 1) * (row[index].sign)
		}
	}

	matrix2string { |separator = " "|
		var shape = this.shape;
		^switch(shape.size,
			1, { this.join(separator) },
			2, { this.padAllStrings2.collect(_.join(separator)).join("\n") },
			{ "[\n" ++ this.collect { |row| row.asCompileString } ++ "\n]" }
		)
	}

	postMatrix {
		this.matrix2string(" ").postln
	}

	// generate path from a movement, starting at point origin
	collectMoves { |origin, scaleFactor = 1|
		var p = origin;
		^([origin] ++ this.collect { |move|
			p = p.copy;
			move.asArray.do { |each|
				var i = each.abs - 1;
				p[i] = p[i] + (scaleFactor.value * each.sign)
			};
			p
		}).centerPath
	}

	centerPath {
		var d = this.flop;
		var minima = d.collect(_.minItem);
		var maxima = d.collect(_.maxItem);
		var center = (maxima + minima) * 0.5;
		^this.collect { |x| x - center }
	}

	floorPath {
		var minima = this.flop.collect(_.minItem);
		^this.collect { |x| x - minima }
	}


	padAllStrings2 { |char = $ |
		var size = 0;
		var strings = this.collect { |x|
			x.collect { |y|
				y = y.asString;
				size = max(size, y.size);
				y
			}
		};
		^strings.collect { |x|
			x.collect { |y|
				y.padString(size, char)
			}
		}
	}


}

+ String {

	removeMultipleWhitespace {
		var new = String.new(this.size);
		this.doAdjacentPairs { |a, b|
			if(not(a.isSpace and: { b.isSpace })) { new = new.add(a) }
		};
		^new
	}

	padString { |size, char = $ |
		var n = this.size;
		if(size <= n) { ^this };
		^this ++ String.fill(size - n, char)
	}
}

+ SimpleNumber {

	asDigits { |base, resolution = 1|
		var mul = resolution.reciprocal;
		^(this * mul).asInteger.asDigits(base)
	}
}