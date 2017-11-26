

TestArrayMatrixOps : UnitTest {



	test_rotate {

		var test;

		test = { |text, matrix, result|
			var rotated = [1, 1].rotatePoint(matrix);
			this.assertEquals(rotated, result, "rotation % should be correct".format(text));

		};

		[
			["90° counter clockwise", [[0, -1], [1, 0]], [-1, 1]],
			["180° counter clockwise",[[-1, 0], [0, -1]], [-1, -1]],
			["270°counter clockwise", [[0, 1], [-1, 0]], [1, -1]]
		].do { |each| test.(*each) }
	}




	test_matrixMul {
		var a, b, c, x;

		a =  [
			[-1,  1,  4],
			[ 6, -4,  2],
			[-3,  5,  0],
			[ 3,  7, -2]
		];

		b = [
			[-1,  1,  4,  8],
			[ 6,  9, 10,  2],
			[11, -4,  5, -3]
		];

		c =  [
			[51, -8, 26, -18],
			[-8, -38, -6, 34],
			[33, 42, 38, -14],
			[17, 74, 72, 44]
		];

		x = mulMatrix(a, b);

		this.assertEquals(x, c, "matrix multiplication should pass simple test");
		this.assert(x != mulMatrix(b, a), "matrix multiplication should be noncommutative");


	}

	test_conversions {
		var test = { |perm|
			var perm2 = perm.permute2matrix.matrix2permute;
			this.assertEquals(perm, perm2, "conversions between permutations and matrices should be invariant");
		};
		test.([2,3,-1]);
		test.([2,1,-3]);
		test.([1, 3, 2, 5, -4]);

	}



}


