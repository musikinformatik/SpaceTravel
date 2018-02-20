

+ SequenceableCollection {
	plotPointPath { |title = "untitled", bounds, dur = 0.1|
		^SpaceTravelImage(title, bounds).addPath(this, dur)
	}
}