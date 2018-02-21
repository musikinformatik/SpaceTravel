/*

this utility draws a 2D image of a path
todo: integrate 3D code

*/


SpaceTravelImage  {

	var <window, <task;
	var <downPoint, <downZoom = 0, <>zoom = 0;

	*new { |title, bounds|
		^super.new.init(title, bounds)
	}

	init { |title, bounds|

		window = Window(title, bounds).background_(Color.white);
		downPoint = Point(1, 1) * window.bounds.width / 2;

		window.view.mouseDownAction = { |v, x, y|
			downPoint = Point(x, y);
		};

		window.view.mouseMoveAction = { |v, x, y|
			var dist;
			if(downPoint.notNil) {
				dist = y - downPoint.y;
				zoom = downZoom + 1 * (dist  / 500);
				this.refresh;
			}
		};
		window.view.mouseUpAction = { |v, x, y|
			downZoom = zoom;
		};

		window.front;
	}



	addPath { |reihe, dur = 0, color|
		var j = 1;
		var max, min, step, scale, points, zoomPoint;
		var width = window.bounds.width * 0.9;

		color = color ? Color.black;

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




		window.drawFunc = window.drawFunc.addFunc({
			var p;
			Pen.matrix = [1, 0, 0, -1, 20 , width + 20];
			Pen.strokeColor = color;
			Pen.smoothing = false;
			Pen.width = 1;
			Pen.moveTo(zoomPoint.(points.first));
			p = if(dur > 0) { points.keep(j) } { points };

			p.do { |point|
				Pen.lineTo(zoomPoint.(point))
			};

			Pen.stroke;
			j = j + 1;
		});

		if(dur.notNil and: task.isPlaying.not) {
			task = fork({ while { window.isClosed.not } { dur.value.wait; window.refresh } }, AppClock);
		};

	}


}

