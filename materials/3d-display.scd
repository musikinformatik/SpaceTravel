// 3 d curves

Quarks.install("Canvas3D");

(
f = { |paths|


	var width = 500, height = 400, rate = 0.005;
	var w, u, downPoint, item;


	w = Window("there is no place like space", Rect(128, 64, width, height), false)
	.front;

	u = Canvas3D(w, Rect(0, 0, width, height))
	.background_(Color.black)
	.scale_(200)
	.perspective_(0.4)
	.distance_(1.8);

	// add triangular spiral
	u.add(
		item = Canvas3DItem()
		.color_(Color.green)
		.width_(0.5)
		.paths_(paths)
	);

	// add cube
	u.add(
		Canvas3DItem.cube
		.color_(Color.white)
		.width_(0.2)
	);



	u.mouseDownAction = { |v, x, y|
		downPoint = [x, y];
	};

	// spin canvas on mouse move
	u.mouseMoveAction = {|v,x,y, mod|
		var dist = downPoint - [x, y];
		if(mod.isAlt) {
			u.transforms = [
				Canvas3D.mRotateY(dist[0] / 200 % 2pi),
				Canvas3D.mRotateZ(dist[1] / -200 % 2pi)
			];
		} {
			u.transforms = [
				Canvas3D.mRotateY(dist[0] / 200 % 2pi),
				Canvas3D.mRotateX(dist[1] / -200 % 2pi)
				//u.distance = dist[0] * 0.01
			];
		};
		u.refresh;
	};

	(view:u, item:item)
};

//f.([2000.collect {|i| sin(i).cubed.dup(3).rand }]);
)

a = SpaceTravel.readFile("../traversals/HarmoniousHilbert3.hx".resolveRelative);
x = f.([a.traversal.generateFullPath(3).centerPath] * 0.1);



(
a = SpaceTravel.readFile("../traversals/HarmoniousHilbert2.hx".resolveRelative);
p = a.traversal.generateFullPath(4).collect { |x| x ++ 10.rand };
f.([p.centerPath] * 0.1);
)




// adding and removing stuff.

x[\view].remove(x[\item]);
x[\view].refresh;
(
x[\view].add(
		Canvas3DItem()
		.color_(Color.green)
		.width_(0.5)
		.paths_([a.traversal.generateFullPath(3).centerPath] * 0.05)
	);
)
x[\view].refresh;

x.paths = [[a.traversal.generateFullPath(3).centerPath] * 0.05];
