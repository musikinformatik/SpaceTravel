

TraversalStack {

	var <traversal, <indices;
	var <index, <depth;
	var <indexStack, <traversalStack;
	var <>maxDepth;
	var <>verbose = true;

	*new { |traversal, indices|
		^super.newCopyArgs(traversal, indices).init
	}

	init {
		indexStack = [];
		traversalStack = [];
		index = 0;
		depth = 0;
		maxDepth = indices.size;
		this.travelDown;
	}


	travelDown {
		while {
			(depth + 1) <= maxDepth
		} {
			depth = depth + 1;
			index = indexStack.at(depth);
			if(index.isNil) {
				index = 0;
				indexStack = indexStack.add(index)
			};
			if(verbose) { "travel down, depth %, index %".format(depth, index).postln };
			traversal = traversal.subTraversal(index);
			traversalStack = traversalStack.add(traversal);
		};
		^traversal
	}

	travelUp {
		var size, parentTraversal;
		while {
			parentTraversal = traversalStack.last;
			index = indexStack.last;
			size = parentTraversal.size;
			index.notNil and: { (index + 1) >= size  }
		} {
			indexStack.pop;
			traversalStack.pop;
			traversal = parentTraversal;
			depth = depth - 1;
			if(verbose) { "travel up, depth %, index %".format(depth, index).postln };
		};
		^traversal
	}

	// todo: get rid of double index bookkeeping.
	travelNext {
		var ii = indexStack.lastIndex;
		if(ii.isNil) {
			"--  ending --".postln;
			this.init; // for now, we just loop.
		} {
			index = index + 1;
			indexStack[ii] = index;
			if(verbose) { "travel next, depth %, index %".format(depth, index).postln };
		}
	}


	next {
		var size = indexStack.size;
		index = indexStack[size - 1];
		traversal = traversalStack[size - 1];
		if(traversal.size <= (index + 1) or: { depth > size }) {
			"travelling ...".postln;
			this.travelUp;
			this.travelNext;
			this.travelDown;
		} {
			//if(indexStack.isEmpty) { ^nil };
			this.travelNext
		};
		^traversal
	}

	value { |func|
		func.value(traversal, index)
	}


}