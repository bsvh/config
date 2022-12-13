# Setup nix environment
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
	source $HOME/.nix-profile/etc/profile.d/nix.sh
	export XDG_DATA_DIRS="$HOME/.nix-profile/share/:$XDG_DATA_DIRS"
fi
if [ -e $HOME/.nix-profile/etc/profile.d/bash_completion.sh ]; then
	source $HOME/.nix-profile/etc/profile.d/bash_completion.sh
fi

# Enable GnuPG SSH
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

export CARGO_HOME="$HOME/.local/sdk/rust/cargo"
export RUSTUP_HOME="$HOME/.local/sdk/rust/cargo"
if [[ -d "${CARGO_HOME}/bin" ]]; then
	echo "$PATH" | grep -q "${CARGO_HOME}/bin"
	[ $? -eq 1 ] && export PATH="${CARGO_HOME}/bin:${PATH}"
fi

# Execute fish for interactive shells
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && $(which fish 2>/dev/null) && -z ${BASH_EXECUTION_STRING} ]]; then
	exec fish
fi
