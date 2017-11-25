

TestArrayMatrixOps : UnitTest {


	test_rotate {
		var point = [-2, 1, 4];
		var matrix = [
			[0, 3],
			[-2, -1],
			[0, 4]

		];
		var rotated = point.rotatePoint(matrix);
		var multipled = [point].mulMatrix(matrix).unbubble;
		this.assertEquals(rotated, multipled, "rotation should be the same as matrix multiplication");


	}

	test_matrixMul {
		var a, b, x, y;

		a = [
			[1, 0, -2],
			[0, 3, -1]

		];

		b = [
			[0, 3],
			[-2, -1],
			[0, 4]

		];

		x = mulMatrix(a, b);
		y =  [ [ 0, -5 ], [ -6, -7 ] ];
		this.assertEquals(x, y, "matrix multiplication should pass simple test");
		this.assert(x != mulMatrix(b, a), "matrix multiplication should be noncommutative");


	}



}


