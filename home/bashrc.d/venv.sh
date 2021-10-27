# Virtual environment helpers
# ---------------------------

function _venv_get_filesystem() {
	df -PTh "$1" | tail -n1 | awk '{print $1 }'
}


# Quickly activate a venv in a standard location
alias -- ++venv=_venv_up
function _venv_up() {
	local cwd=$( cd "$( readlink -e "$( pwd )" )" && pwd )
	if [[ $# -ge 1 ]] ; then
		local search_upwards="false"
		local dir="$( realpath -eLP "${1%%/}" )"
	else
		local search_upwards="true"
		local dir="$( pwd )"
	fi
	local locations=( 'venv/bin' '.hsenv_main/bin' '.cabal-sandbox/bin' 'node_modules/.bin' )

	local initial_filesystem="$( _venv_get_filesystem "$dir" )"

	local py="$PYTHON_VENV_NAME"
	local conda=".conda"
	local node='node_modules'
	local haskell='.cabal-sandbox'

	local path=()
	local activate=()

	while ! [ -z "$dir" ] ; do

		local found=false

		if [[ -d "$dir/$py" ]] ; then
			echo "Using Python virtualenv: $dir/$py"
			activate+=( "$( printf 'source %q/%q/bin/activate' "$dir" "$py" )" )
			found=true
		fi
		if [[ -d "$dir/$conda" ]] ; then
			echo "Using conda environment: $dir/$conda"
			activate+=( "$( printf 'conda activate %q/%q' "$dir" "$conda" )" )
			found=true
		fi
		if [[ -d "$dir/$node" ]] ; then
			echo "Using node envionment: $dir/$node"
			path+=( "$dir/$node/.bin" )
			found=true
		fi
		if [[ -d "$dir/$haskell" ]] ; then
			echo "Using Haskell sandbox: $dir/$haskell"
			path+=( "$dir/$haskell/bin" )
			found=true
		fi

		if $found ; then
			(
				if [[ "${#path}" -gt 0 ]] ; then
					export PATH="$(IFS=':' ; echo "${path[*]}"):$PATH" ;
				fi
				for cmd in "${activate[@]}" ; do
					eval "$cmd" ;
				done
				export VENV_DIR="$dir"
				exec $SHELL
			)
			return 0
		fi

		if [[ "$search_upwards" == "true" ]] ; then
			new_dir=$( dirname "$dir" )
			if [ "$initial_filesystem" != "$( _venv_get_filesystem "$new_dir" )" ] ; then
				echo  "Could not find venv to activate, crossed file system boundary at $dir" >&2
				return 2
			fi
			if [ "$dir" == "/" ] && [ "$new_dir" == "/" ] ; then
				echo 'Could not find venv to activate' >&2
				return 1
			fi
		else
			echo 'Could not find venv to activate in' "$1" >&2
			return 1
		fi
		dir="$new_dir"
	done

	echo 'Could not find venv to activate' >&2
	return 1
}

# Deacticate a venv, assuming it is standard and uses `deactivate()`
alias -- --venv=_venv_down
function _venv_down() {
	exit
}
