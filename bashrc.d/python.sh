# Python configuration and helpers
# --------------------------------

# Settings for python shells
export PYTHONSTARTUP=~/.pythonrc

# Cache pip downloads, for faster installs
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

# Warn about using the global pip. This usually means we forgot to activate a
# virtualenv
system_pip=`which pip`
last_pip_time=0
pip_cooldown=300 # five minutes
function pip() {
	current_pip=`which pip`
	if [[ "$current_pip" == "$system_pip" ]] ; then
		current_time="$( date +%s )"
		if [[ "$(( $last_pip_time + $pip_cooldown ))" -le $current_time ]] ; then
			echo "You are using the system-wide pip."
			read -r -p "Are you sure you want to do this? [y/N] " response
		else
			response="y"
		fi

		case $response in
			[yY])
				$current_pip $@
				last_pip_time=$current_time
				;;
			*) ;;
		esac
	else
		$current_pip $@
	fi
}

# Make and source a virtualenv in the current directory
function mkvenv.python() {
	dir="${1:-.}"
	virtualenv "$dir/venv"
	++venv "$dir"
	[ -e "${dir}/requirements.txt" ] && pip install -r "${dir}/requirements.txt"
}
