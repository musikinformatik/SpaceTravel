
SpaceTravel {

	var <traversal;
	var <permutations, <movements, <dimension;
	var <text;

	*new { |string|
		^super.new.parseString(string)
	}

	*readFile { |path|
		^super.new.readFile(path)
	}

	readFile { |path|
		var string;
		File.use(path.standardizePath, "r", { |file|
			string = file.readAllString;
		});
		this.parseString(string);
	}

	parseString { |string|

		var transformStrings, locationStrings, parts;
		var transformations, directions, locations;

		text = string;

		string = this.pruneString(string);
		parts = this.partitionString(string);

		transformStrings = parts[1, 3..];
		locationStrings = parts[0, 2..];

		transformStrings = transformStrings.collect(this.partitionString(_)).flatten(1);

		#permutations, directions = this.parseTransformations(transformStrings);
		movements = this.parseMovements(locationStrings);
		dimension = movements.flat.abs.maxItem;

		transformations = this.transformationCoordinates;
		locations = this.locationCoordinates;

		traversal = Traversal(transformations, directions, locations);

	}

	pruneString { |string|
		var begin, end;
		begin = string.find("\n<");
		if(begin.isNil) {  Error("couldn't find an opening bracket '<'").throw };
		string = string[begin+2..];
		end = string.find("\n>");
		if(end.isNil) { Error("couldn't find a closing bracket '>'").throw };
		^string[..end-1]
	}

	locationCoordinates { |origin, scaleFactor = 1|
		var p = origin ?? { 0.dup(dimension) };
		^movements.collect { |move|
			p = p.copy;
			move.asArray.do { |each|
				var i = each.abs - 1;
				p[i] = p[i] + (scaleFactor.value(each) * each.sign)
			};
			p
		}
	}

	transformationCoordinates {
		^permutations.collect(permute2matrix(_));
	}

	parseTransformations { |chunks|
		^chunks.collect { |string|
			var direction, transformation, rotation;
			direction = switch(string.first, ${, -1, $[, 1, { Error("invalid opening").throw });
			switch(string.last,
				$}, { if(direction != 1) { Error("invalid closing" + string).throw } },
				$], { if(direction != -1) { Error("invalid closing" + string).throw } },
				{ Error("invalid closing" + string).throw  }
			);
			rotation = string.drop(1).drop(-1).split($ ).reject(_ == "").collect(_.asInteger);
			[rotation, direction]
		}.flop
	}

	partitionString { |text|
		^text.replace("\n", " ").separate { |a, b|
			"[{".includes(b) or: { "}]".includes(a) }
		}
	}

	parseMovements  { |chunks|
		^chunks.collect { |string|
			string.split($ ).collect(_.asInteger).reject(_ == 0); // remove and ignore all wrong format
		}.reject(_.isEmpty)
	}

	printOn { |stream|
		stream << this.class.name << "(\"\n";
		stream << text << "\"\n)\n";
	}


}


/*
// post some information
		stream << Char.nl;
		stream << "Locations:" << Char.nl;
		stream << this.locations.collect(_.join(" ")).join(" | ") << Char.nl;
		stream << "Transformations:" << Char.nl;
		stream << permutations.collect(_.join(" ")).join(" | ") << Char.nl;
		stream << "Directions:" << Char.nl;
		stream << directions.join(" | ") << Char.nl;
*/