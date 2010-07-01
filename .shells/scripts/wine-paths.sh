#!/bin/bash

for file in ~/.wine/dosdevices/* ; do
	drive=`basename "$file" | sed 's/^\([a-zA-Z]\):*$/\1:/'`
	eval "function $drive {
		cd $file
	}"
done
