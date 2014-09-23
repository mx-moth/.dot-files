# Virtual environment helpers
# ---------------------------

function venv.get_filesystem() {
	df -PTh "$1" | tail -n1 | awk '{print $1 }'
}


# Quickly activate a venv in a standard location
function ++venv() {
	local cwd=$( cd "$( readlink -e "$( pwd )" )" && pwd )
	local dir="${1:-"$cwd"}"
	local locations=( 'venv/bin' '.hsenv_main/bin' '.cabal-sandbox/bin' 'node_modules/.bin' )

	local initial_filesystem="$( venv.get_filesystem "$dir" )"

	while ! [ -z "$dir" ] ; do

		local found=false
		local env=()
		local path="$PATH"

		if [[ -d "$dir/venv" ]] ; then
			echo "Using Python virtualenv: $dir/venv"
			env+=("VIRTUAL_ENV=$dir/venv")
			path="$dir/venv/bin:$path"
			found=true
		fi
		if [[ -d "$dir/node_modules" ]] ; then
			echo "Using node envionment: $dir/node_modules"
			path="$dir/node_modules/.bin:$path"
			found=true
		fi
		if [[ -d "$dir/.cabal-sandbox" ]] ; then
			echo "Using Haskell sandbox: $dir/.cabal-sandbox"
			path="$dir/.cabal-sandbox/bin:$path"
			found=true
		fi

		if $found ; then
			env VENV_DIR="$dir" PATH="$path" "${env[@]}" $SHELL
			return 0
		fi

		new_dir=$( dirname "$dir" )
		if [ "$initial_filesystem" != "$( venv.get_filesystem "$new_dir" )" ] ; then
			echo  "Could not find venv to activate, crossed file system boundary at $dir" >&2
			return 2
		fi
		if [ "$dir" == "/" ] && [ "$new_dir" == "/" ] ; then
			echo 'Could not find venv to activate' >&2
			return 1
		fi
		dir="$new_dir"
	done

	echo 'Could not find venv to activate' >&2
	return 1
}

# Deacticate a venv, assuming it is standard and uses `deactivate()`
function --venv() {
	exit
}
