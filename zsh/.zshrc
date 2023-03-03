export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="mandy"



detect_os() {
	## OS and Architecture
	if [ -f /etc/os-release ]; then
			# freedesktop.org and systemd
			. /etc/os-release
			OS="$NAME"
			VER="$VERSION_ID"
	elif type lsb_release >/dev/null 2>&1; then
			# linuxbase.org
			OS=$(lsb_release -si)
			VER=$(lsb_release -sr)
	elif [ -f /etc/lsb-release ]; then
			# For some versions of Debian/Ubuntu without lsb_release command
			. /etc/lsb-release
			OS=$DISTRIB_ID
			VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
			# Older Debian/Ubuntu/etc.
			OS=Debian
			VER=$(cat /etc/debian_version)
	elif [ -f /etc/SuSe-release ]; then
			# Older SuSE/etc.
			...
	elif [ -f /etc/redhat-release ]; then
			# Older Red Hat, CentOS, etc.
			...
	else
			# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
			OS="$(uname -s)"
			VER="$(uname -r)"
	fi
	export OS
	export VER
}



detect_os


plugins=(
    colored-man-pages
    command-not-found
    cp # This plugin defines a cpv function that uses rsync so that you get the features and security of this command.
    extract
    # fzf-tab
    z
    # zsh-autosuggestions
    # zsh-syntax-highlighting
)

zstyle ':completion:*:make::' tag-order targets
zstyle ':completion:*' special-dirs false


if [ "$OS" = "Ubuntu" ]; then
    plugins+=(ubuntu)
elif [ "$OS" = "Arch Linux" ]; then
    plugins+=(archlinux)
elif [ "$OS" = "Fedora" ]; then
    plugins+=(fedora)
fi

if [[ $commands[adb] ]]; then plugins+=(adb); fi
if [[ $commands[nmap] ]]; then plugins+=(nmap); fi
if [[ $commands[git] ]]; then plugins+=(git); fi
if [[ $commands[docker] ]]; then plugins+=(docker); fi
if [[ $commands[docker-compose] ]]; then plugins+=(docker-compose); fi
if [[ $commands[vagrant] ]]; then plugins+=(vagrant); fi
if [[ $commands[rsync] ]]; then plugins+=(rsync); fi
if [[ $commands[sudo] ]]; then plugins+=(sudo); fi
if [[ $commands[minikube] ]]; then
    source <(minikube completion zsh)
fi
if [[ $commands[kubectl] ]]; then
    source <(kubectl completion zsh)
fi
if [[ $commands[k3d] ]]; then
    source <(k3d completion zsh)
fi
if [[ $OS = 'Linux' ]]; then 
#    plugins+=(notify)
    plugins+=(systemd) # The systemd plugin provides many useful aliases for systemd. https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/systemd);
fi

# plugins+=(zsh-completions)


zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"


zstyle :omz:plugins:ssh-agent agent-forwarding on

if [[ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
    # shellcheck source=./.oh-my-zsh/oh-my-zsh.sh
    # shellcheck disable=SC1094
    source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
fi


if [[ $commands[dircolors] ]] && [[ -f ~/.dircolors ]]; then
    eval "$(dircolors ~/.dircolors)";
fi


# export HISTFILE="$HOME/.zhistory"
HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY


alias rcp='rsync -ahrt --info progress2'
alias rmv='rsync -ahrt --info progress2 --remove-sent-files'


if [[ $commands[thefuck] ]]; then eval "$(thefuck --alias)"; fi

if [[ $commands[pbcopy] ]]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi


title() {
	print -Pn "\e]0;$1\a"
}


export VISUAL="vim"
export EDITOR='vim'
export TZ='Europe/Brussels'
export DISABLE_AUTO_TITLE=true

# @see https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/correction.zsh
export ENABLE_CORRECTION="false"
unsetopt correct_all



# Uncomment the following line to display red dots whilst waiting for completion.
export COMPLETION_WAITING_DOTS="true"

export AUTO_TITLE=false

export ARCH_BITS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export CHEATCOLORS=true

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export BUILDKIT_INLINE_CACHE=1

# export IP_ADDRESS=$(ip_address)
export HOSTNAME="$(hostname)"
export USER="$(whoami)"

# ssh-agent omzsh should do the same
if [[ $OS = 'Linux' ]] && command -v ssh-agent &>/dev/null; then
    # export SUDO_ASKPASS=/usr/libexec/openssh/gnome-ssh-askpass

    # Launch SSH agent if not running
    if ! pgrep -f "ssh-agent" --uid "$(id -u)" &>/dev/null; then ssh-agent ; fi

    # Link the latest ssh-agent socket
    mkdir -p ~/.ssh/
    ln -sf "$(find "${TMPDIR:-/tmp}" -maxdepth 2 -type s -name 'agent*' -user "$(whoami)" -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2)" ~/.ssh/ssh_auth_sock
    ssh-add -l > /dev/null || ssh-add

    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi


if [[ $OS = Darwin ]]; then
    export DISPLAY="$HOSTNAME:0"
fi


# bindkey  "^[[1~"   beginning-of-line
# bindkey  "^[[4~"   end-of-line

# Make ctrl+backpace and ctrl+delete work in zsh
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

if [[ $commands[fd] ]]; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor --exclude .mypy-cache'
fi

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=5
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_PATTERNS

#shellcheck disable=SC2190
# To have commands starting with `rm -rf` in red:
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=red,bold')


# https://stackoverflow.com/questions/6429515/stty-hupcl-ixon-ixoff
# Disable CTRL-Z
if [[ -t 0 ]]; then
	stty -ixon -ixoff
fi

if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
  . ~/.nix-profile/etc/profile.d/nix.sh
fi



if [[ -f "$HOME/.bash_aliases" ]]; then
    # shellcheck source=.bash_aliases
    source "$HOME/.bash_aliases"
fi


if [[ -f "$HOME/.sharedrc" ]]; then
    source "$HOME/.sharedrc"
fi