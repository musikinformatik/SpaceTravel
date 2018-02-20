

+ SequenceableCollection {

	plotPointPath { |title = "untitled", bounds, dur = 0.1|

		var max, min, step, scale, mid, points;
		var w, width;
		var j = 0;
		var offset;

		w = Window(title, bounds);
		w.background = Color.white;
		w.front;


		max = this.flat.maxItem;
		min = this.flat.minItem;
		scale = max - min;
		width = w.view.bounds.width;
		offset = width div: 2;


		points = this.collect { |pair|
			pair = pair.postln.linlin(min, max, 10, offset - 10);
			Point(*pair)
		};

		w.drawFunc = {
			Pen.matrix = [1, 0, 0, -1, offset/2, offset*3/2];
			Pen.strokeColor = Color.black;
			Pen.smoothing = false;
			Pen.moveTo(points @ 0);
			points.keep(j).do { |point|
				Pen.lineTo(point);
			};

			Pen.stroke;
			j = j + 1;
		};

		fork({ while { w.isClosed.not } { dur.wait; w.refresh; } }, AppClock);

	}
}