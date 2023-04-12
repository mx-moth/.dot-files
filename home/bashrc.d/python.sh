# Python configuration and helpers
# --------------------------------

# Don't bother if Python isn't installed
if ! command? python3 ; then return ; fi

# Settings for python shells
export PYTHONSTARTUP="$HOME/.pythonrc"
export PYTHONDONTWRITEBYTECODE=1

PYTHON_VENV_NAME=".venv"


# Make and source a virtualenv in the current directory
alias mkvenv.python=_mkvenv_python
function _mkvenv_python() {
	local venv="$PYTHON_VENV_NAME"
	local dir="${1:-`pwd`}"
	local pip="${dir}/$venv/bin/pip"
	python3 -mvenv "$dir/$venv"

	"$pip" install --upgrade pip wheel

	args=()
	if [ -e "${dir}/requirements.txt" ] ; then
		args+=(-r "${dir}/requirements.txt")
	fi
	if [ -e "${dir}/setup.py" ] || [ -e "${dir}/setup.cfg" ] ; then
		args+=(-e "${dir}")
	fi
	if [[ "${#args[@]}" -gt 0 ]] ; then
		"$pip" install "${args[@]}"
	fi

	_venv_up "$dir"
}


# Find all __pycache__ directories and delete them
function rmpycache() {
	find "${1:-.}" -name '__pycache__' -type 'd' -exec rm -rf '{}' '+' -prune
}
