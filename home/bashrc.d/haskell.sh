# Haskell configuration and helpers
# --------------------------------

# Warn about using the global cabal. This usually means we forgot to activate a
# virtualenv
system_cabal=`which cabal &>/dev/null`
if [[ -n "$system_cabal" ]] ; then
	last_cabal_time=0
	cabal_cooldown=300 # five minutes
	function cabal() {
		current_cabal=`which cabal`
		if [[ "$current_cabal" == "$system_cabal" ]] ; then
			current_time="$( date +%s )"
			if [[ "$(( $last_cabal_time + $cabal_cooldown ))" -le $current_time ]] ; then
				echo "You are using the system-wide cabal"
				read -r -p "Are you sure you want to do this? [y/N] " response
			else
				response="y"
			fi

			case $response in
				[yY])
					$current_cabal $@
					last_cabal_time=$current_time
					;;
				*) ;;
			esac
		else
			$current_cabal $@
		fi
	}
fi
unset system_cabal

if command? 'hsenv' ; then
	HASKELL_VENV_NAME='.cabal-sandbox'

	# Make and source a virtualenv in the current directory
	alias mkvenv.haskell=_mkvenv_haskell
	function _mkvenv_haskell() {
		dir="${1:-.}"
		( cd "$dir" && hsenv --name=main )
		++venv "$dir"
		[ -e "${dir}/cabal.config" ] && ( cd "$dir" && cabal install --dependencies-only )
	}
fi
