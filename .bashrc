# shellcheck shell=bash
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	# shellcheck disable=SC1091
	. /etc/bashrc
fi

# User specific environment
# shellcheck disable=SC2076
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

if [ -d ~/.shellrc.d ]; then
  for rc in ~/.shellrc.d/*; do
    if [ -f "$rc" ]; then
        # shellcheck disable=SC1090
        . "$rc"
    fi
  done
fi



if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			# shellcheck disable=SC1090
			. "$rc"
		fi
	done
fi

unset rc
