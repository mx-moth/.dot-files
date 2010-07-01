#!/bin/bash

for file in ~/.shells/links/* ; do
	path=`cat "$file"`
	name=`basename $file`
	eval "
	function .$name() {
		cd \"$path\"
	}"
done
