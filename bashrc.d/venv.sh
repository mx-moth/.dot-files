# Virtual environment helpers
# ---------------------------

function venv::get_filesystem() {
	df -PTh "$1" | tail -n1 | awk '{print $1 }'
}


# Quickly activate a venv in a standard location
function ++venv() {
	cwd=$( cd "$( readlink -e "$( pwd )" )" && pwd )
	path="${1:-"$cwd"}"
	locations=( 'venv' '.virthualenv' )

	initial_filesystem="$( venv::get_filesystem "$path" )"

	while ! [ -z "$path" ] ; do

		for location in "${locations[@]}" ; do
			if [[ -d $path/$location ]] ; then
				echo "Activating $path/$location"
				source $path/$location/bin/activate
				return 0
			fi
		done

		new_path=$( dirname "$path" )
		if [ "$initial_filesystem" != "$( venv::get_filesystem "$new_path" )" ] ; then
			echo  "Could not find venv to activate, crossed file system boundary at $path" >&2
			return 2
		fi
		if [ "$path" == "/" ] && [ "$new_path" == "/" ] ; then
			echo 'Could not find venv to activate' >&2
			return 1
		fi
		path="$new_path"
	done

	echo 'Could not find venv to activate' >&2
	return 1
}

# Deacticate a venv, assuming it is standard and uses `deactivate()`
function --venv() {
	deactivate
}
