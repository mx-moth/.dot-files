# Virtual environment helpers
# ---------------------------

# Quickly activate a venv in a standard location
function ++venv() {
	base="${1:-.}"
	locations=( 'venv' '.virthualenv' )
	paths=( "$base" "$base/.." )

	for path in "${paths[@]}" ; do
		for location in "${locations[@]}" ; do
			if [[ -d $path/$location ]] ; then
				source $path/$location/bin/activate
				return 0
			fi
		done
	done

	echo 'Could not find venv to activate' >&2
	return 1
}

# Deacticate a venv, assuming it is standard and uses `deactivate()`
function --venv() {
	deactivate
}
