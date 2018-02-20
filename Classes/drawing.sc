SpaceTravelImage : UserView {

	var <downPoint, <downZoom = 0, <>zoom = 0;

	*new { |parent, bounds|
		^super.new(parent, bounds).init
	}

	init {

		downPoint = Point(1, 1) * this.bounds.width / 2;

		this.mouseDownAction = { |v, x, y|
			downPoint = Point(x, y);
		};

		this.mouseMoveAction = { |v, x, y|
			var dist;
			if(downPoint.notNil) {
				dist = y - downPoint.y;
				zoom = downZoom + 1 * (dist  / 500);
				this.refresh;
			}
		};
		this.mouseUpAction = { |v, x, y|
			downZoom = zoom;
		};
	}


	addPath { |reihe, dur, color|
		var j = 1;
		var max, min, step, scale, points, zoomPoint;
		var width = this.bounds.width * 0.9;


		max = reihe.flat.maxItem;
		min = reihe.flat.minItem;
		scale = max - min;

		points = reihe.collect { |pair|
			pair = pair.linlin(min, max, 10, width - 10);
			//pair = 180 - pair + min * 2;
			Point(*pair)
		};


		zoomPoint = { |point|
			var dist = point - downPoint;
			point + (zoom * dist);
		};


		drawFunc = drawFunc.addFunc({
			var p;
			Pen.matrix = [1, 0, 0, -1, 20 , width + 20];
			Pen.strokeColor = color;
			Pen.smoothing = false;
			Pen.width = 1;
			Pen.moveTo(zoomPoint.(points.first));
			p = if(dur > 0) { points.keep(j) } { points };

			p.do { |point|
				Pen.lineTo(zoomPoint.(point).postln)
			};

			Pen.stroke;
			j = j + 1;
		});

		this.refresh;

	}

}

