# Conda configuration and helpers
# --------------------------------

export CONDA_AUTO_ACTIVATE_BASE=false
CONDA_PREFIX_NAME=".conda"

# Look for possible conda install locations

if command? conda ; then
	noop
elif [[ -v CONDA_ROOT ]] ; then
	eval "$( "${CONDA_ROOT}/bin/conda" shell.bash hook )"
else
	CONDA_POSSIBLE_ROOTS=(
		"$HOME/.local/share/miniconda3"
	)

	for CONDA_POSSIBLE_ROOT in "${CONDA_POSSIBLE_ROOTS[@]}" ; do
		if [[ -d "$CONDA_POSSIBLE_ROOT" ]] ; then
			CONDA_ROOT="$CONDA_POSSIBLE_ROOT"
			break
		fi
	done

	unset CONDA_POSSIBLE_INSTALL_DIRECTORIES CONDA_POSSIBLE_ROOT
	if ! [[ -v CONDA_ROOT ]] ; then return ; fi
fi

if ! command? conda ; then
	eval "$( "${CONDA_ROOT}/bin/conda" shell.bash hook )"
fi

unset CONDA_ROOT


alias mkvenv.conda=_mkvenv_conda
function _mkvenv_conda() {
	local conda="$CONDA_PREFIX_NAME"
	local dir="$( pwd )"

	conda create \
		--yes --quiet \
		--no-default-packages \
		--prefix "$dir/$conda" \
		"$@"

	_venv_up "$dir"
}
