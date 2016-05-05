#!/bin/bash

nvim=~/.config/nvim
mkdir -p $nvim/bundle.bad
mv "$nvim"/bundle/* "$nvim"/bundle.back
mv "$nvim"/bundle.back/neomake "$nvim"/bundle
mv "$nvim"/bundle.back/colors "$nvim"/bundle
mv "$nvim"/bundle.back/airline "$nvim"/bundle

for x in $nvim/bundle.back/* ; do
	plugin=$( basename "$x")
	mv "$nvim/bundle.back/$plugin" "$nvim/bundle/$plugin"
	nvim "$@"
	echo "plugin $plugin"
	read -p "did it work? " -N1 yn
	echo ""
	case "$yn" in
		[nN])
			echo "Quarantine $plugin"
			mv "$nvim/bundle/$plugin" "$nvim/bundle.bad/$plugin"
			;;
		*)
	esac
done
