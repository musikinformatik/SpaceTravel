// 3 d curves

Quarks.install("Canvas3D");

(
f = { |paths, title|


	var width = 500, height = 400, rate = 0.005;
	var w, u, downPoint, downRot, downDistance, downPerspective, item;
	var rotX = 0, rotY = 0, rotZ = 0, prevRotX = 0, prevRotY = 0, prevRotZ = 0;


	w = Window(title ? "there is no place like space", Rect(128, 64, width, height), false)
	.front;

	u = Canvas3D(w, Rect(0, 0, width, height))
	//.background_(Color.black)
	.background_(Color.white)
	.scale_(200)
	.perspective_(0.1)
	.distance_(1.8);

	// add triangular spiral
	u.add(
		item = Canvas3DItem()
		//.color_(Color.green)
		.color_(Color.black)
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
		downDistance = u.distance;
		downPerspective = u.perspective;
	};

	u.mouseUpAction = {
		downPerspective = downDistance = nil;
		prevRotX = rotX;
		prevRotY = rotY;
		prevRotZ = rotZ;
	};

	// spin canvas on mouse move
	u.mouseMoveAction = {|v,x,y, mod|
		var dist = downPoint - [x, y];
		if(mod.isAlt) {
			u.transforms = [
				//Canvas3D.mRotateY(rotY = dist[0] / 200 % 2pi + prevRotY),
				//Canvas3D.mRotateZ(rotZ = dist[0] / -200 % 2pi + prevRotZ)
			];
			u.perspective = dist[1].bilin(0, -200, 200, downPerspective, 0, 0.9);
			//u.distance = dist[1].bilin(0, -200, 200, downDistance, 1, 20);
		} {
			u.transforms = [
				Canvas3D.mRotateY(rotY = dist[0] / 200 % 2pi + prevRotY),
				Canvas3D.mRotateX(rotX = dist[1] / -200 % 2pi + prevRotX)
			];
		};
		u.refresh;
	};

	(view:u, item:item)
};

//f.([2000.collect {|i| sin(i).cubed.dup(3).rand }]);
)

(
a = SpaceTravel.readFile("../traversals/HarmoniousHilbert3.hx".resolveRelative);
x = f.([a.traversal.generateFullPath(3).centerPath] * 0.1, a.name);
)

(
a = SpaceTravel.readFile("../traversals/Peano3.hx".resolveRelative);
x = f.([a.traversal.generateFullPath(2).centerPath] * 0.1, a.name);
)


(
a = SpaceTravel.readFile("../traversals/HarmoniousHilbert2.hx".resolveRelative);
p = a.traversal.generateFullPath(4).collect { |x| x ++ 3.rand };
f.([p.centerPath] * 0.1, a.name);
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
