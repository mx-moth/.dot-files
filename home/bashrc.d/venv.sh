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

	local NODE_VENV_NAME='node_modules'

	local path=()
	local activate=()

	while ! [ -z "$dir" ] ; do

		local found=false

		if [[ -v PYTHON_VENV_NAME && -d "$dir/$PYTHON_VENV_NAME" ]] ; then
			echo "Found Python virtualenv: $dir/$PYTHON_VENV_NAME"
			activate+=( "$( printf 'source %q/%q/bin/activate' "$dir" "$PYTHON_VENV_NAME" )" )
			found=true
		fi
		# Conda always creates a ~/.conda directory to store some state.
		# Yes there are bug reports about it, no they don't seem to care.
		# This will never be an actual environment so lets ignore that case
		if [[ -v CONDA_PREFIX_NAME && -d "$dir/$CONDA_PREFIX_NAME" && "$dir" != "$HOME" ]] ; then
			echo "Found Conda environment: $dir/$CONDA_PREFIX_NAME"
			activate+=( "$( printf 'conda activate %q/%q' "$dir" "$CONDA_PREFIX_NAME" )" )
			found=true
		fi
		if [[ -d "$dir/$NODE_VENV_NAME" ]] ; then
			echo "Found node modules: $dir/$NODE_VENV_NAME"
			path+=( "$dir/$NODE_VENV_NAME/.bin" )
			found=true
		fi
		if [[ -v HASKELL_VENV_NAME && -d "$dir/$HASKELL_VENV_NAME" ]] ; then
			echo "Found Haskell sandbox: $dir/$HASKELL_VENV_NAME"
			path+=( "$dir/$HASKELL_VENV_NAME/bin" )
			found=true
		fi

		if $found ; then
			# In a subshell, activate all the environments and then launch bash again.
			echo ""
			(
				if [[ "${#path}" -gt 0 ]] ; then
					echo "$ export PATH=$(IFS=':' ; echo "${path[*]}"):\$PATH"
					export PATH="$(IFS=':' ; echo "${path[*]}"):$PATH"
				fi
				for cmd in "${activate[@]}" ; do
					echo "\$ $cmd"
					eval "$cmd"
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
