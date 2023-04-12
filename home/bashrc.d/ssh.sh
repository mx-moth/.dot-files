# SSH shortcuts

# Add all keys in ~/.ssh/keys to the keyring
alias ssh-add-all='ssh-add ~/.ssh/keys/*id_rsa'

# Close a multiplexed connection to a server
# Usage: `ssh-close-multiplexed-connection ssh.example.com`
alias ssh-close-multiplexed-connection="ssh -O stop"

function ssh-send-local-port() {
	_usage() {
		cat <<-USAGE
		Usage:
			ssh-send-local-port HOST PORT [REMOTE-PORT]

		Forwards connections to PORT on the local machine to REMOTE-PORT on
		HOST. If REMOTE-PORT is not set, it defaults to the same as PORT.

		Runs in the background. Ctrl-C to kill it.
		USAGE
	}
	if [ $# -lt 2 ] ; then
		_usage >&2
		return 1
	fi
	local host="$1"
	local port="$2"
	local remote_port="$2"
	shift 2;
	if [ $# -ge 1 ] ; then
		local remote_port="$1"
		shift
	fi

	echo "Forwarding connections to local port $port to $host:$remote_port"
	ssh -N -L "$port:localhost:$remote_port" "$host" "$@"
}

function ssh-receive-remote-port() {
	_usage() {
		cat <<-USAGE
		Usage:
			ssh-receive-remote-port HOST PORT [LOCAL-PORT]

		Forwards connections to PORT on HOST to LOCAL-PORT on the local
		machoine. If LOCAL-PORT is not set, it defaults to the same as
		PORT.

		Runs in the background. Ctrl-C to kill it.
		USAGE
	}
	if [ $# -lt 2 ] ; then
		_usage >&2
		return 1
	fi
	local host="$1"
	local port="$2"
	local local_port="$2"
	shift 2;
	if [ $# -ge 1 ] ; then
		local local_port="$1"
		shift
	fi

	echo "Forwarding connections to $host:$port to local port $local_port"
	ssh -N -R "$port:localhost:$local_port" "$host" "$@"
}
