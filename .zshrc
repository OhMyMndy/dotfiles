# shellcheck shell=bash
# shellcheck source-path=../
# shellcheck disable=2155

# shellcheck source=./z.sh
source "$HOME/z.sh"
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="mandy"

#zstyle ':completion:*' use-cache yes

# shellcheck source=.functions
source "$HOME/.functions"

detect_os

# Compleat https://limpet.net/mbrubeck/2009/10/30/compleat.html``
# sysadmin-util https://github.com/skx/sysadmin-util

export FZF_TAB_OPTS="--ansi"
export FZF_COMPLETION_OPTS="${FZF_TAB_OPTS}"

plugins=(
    adb # only works with adb command in path
    colored-man-pages
    command-not-found
    cp # This plugin defines a cpv function that uses rsync so that you get the features and security of this command.
    copydir # Copies the path of your current folder to the system clipboard.
    docker
    docker-compose
    extract
    fzf-tab
    git
    httpie
    jira
    notify
    nmap # https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/nmap
    rsync # rsync-copy rsync-move rsync-update rsync-synchronize
    systemd # The systemd plugin provides many useful aliases for systemd. https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/systemd
    sudo
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
)

if [ "$OS" = "Ubuntu" ]; then
    plugins+=(ubuntu)
elif [ "$OS" = "Arch Linux" ]; then
    plugins+=(archlinux)
elif [ "$OS" = "Fedora" ]; then
    plugins+=(fedora)
fi


# Autoload zsh commands
# autoload -Uz compinit
# if [ "$ZSH_COMPDUMP" != '' ] && [[ $(find "$ZSH_COMPDUMP" -mtime +100 -print) ]]; then
# 	compinit
# else
# 	compinit -C;
# fi

if [[ -f $HOME/.bash_aliases ]]; then
    # shellcheck source=.bash_aliases
    source "$HOME/.bash_aliases"
fi

if [[ -f $HOME/.profile ]]; then
    # shellcheck source=.profile
    source "$HOME/.profile"
fi


zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"


zstyle :omz:plugins:ssh-agent agent-forwarding on

if [[ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
    # shellcheck source=./.oh-my-zsh/oh-my-zsh.sh
    # shellcheck disable=SC1094
    source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
fi


if [[ -f $HOME/bin/commands-to-aliases ]]; then
    "$HOME/bin/commands-to-aliases" > "$HOME/.aliases"
    # shellcheck source=./.aliases
    source "$HOME/.aliases"
fi

export GEM_HOME=$HOME/.gem
export GEM_PATH=$HOME/.gem

export GOPATH=$HOME/go


if [[ -f $HOME/.lessrc ]]; then
    # shellcheck source=.lessrc
    source ~/.lessrc
fi

compctl -g "$HOME/.teamocil/*(:t:r)" teamocil

if exists dircolors; then
    eval "$(dircolors ~/.dircolors)";
fi


export HISTFILE="$HOME/.zhistory"
HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY


alias docker-ps-min='docker ps --format "table{{.Names}}\t{{.RunningFor}}\t{{.Status}}"'
alias docker-stats-min="docker stats --format 'table {{.Name}}\t{{.MemUsage}}\t{{.CPUPerc}}\t{{.BlockIO}}'"
alias hl='grepc "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
#alias current-window-process='ps -o args= $(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}") -f _NET_WM_PID 0c " \$0\\n" _NET_WM_PID | awk "{print \$2}")'
alias disk-usage='sudo du -h -t200M -x / 2>/dev/null'
# alias xdg-open='exo-open'

# exa aliases
alias dir="exa -lag --git --time-style=long-iso --group-directories-first"
alias dir-sort-size="dir -s=size"
alias dir-sort-size-desc="dir -s=size -r"
alias dir-sort-mod="dir -s=modified"
alias dir-sort-mod-desc="dir -s=modified -r"
alias dir-tree="dir -T -L=2"
alias dir-tree-full="dir -T"


alias rcp='rsync -ahrt --info progress2'
alias rmv='rsync -ahrt --info progress2 --remove-sent-files'

alias lc='colorls -lA --sd'

alias dockly='docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock lirantal/dockly'

# Prevents local TERM from affecting ssh.
alias ssh='TERM=xterm ssh'

# Python aliases
alias ve='python3 -m venv ./venv'
alias va='source ./venv/bin/activate'

# Snapcraft aliases
alias snapcraft-docker='docker run -v "$PWD":/build -w /build snapcore/snapcraft:stable snapcraft'

if exists thefuck; then eval "$(thefuck --alias)"; fi

if ! exists pbcopy; then
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

export ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export CHEATCOLORS=true

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

export IP_ADDRESS=$(ip_address)
export HOSTNAME="$(hostname)"
export USER="$(whoami)"

# ssh-agent omzsh should do the same
if [ "$(uname -s)" != 'Darwin' ]; then
    # export SUDO_ASKPASS=/usr/libexec/openssh/gnome-ssh-askpass

    # Launch SSH agent if not running
    if ! pgrep -f "ssh-agent" --uid "$(id -u)" &>/dev/null; then ssh-agent ; fi

    # Link the latest ssh-agent socket
    mkdir -p ~/.ssh/
    ln -sf "$(find "${TMPDIR:-/tmp}" -maxdepth 2 -type s -name 'agent*' -user "$(whoami)" -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2)" ~/.ssh/ssh_auth_sock
    ssh-add -l > /dev/null || ssh-add

    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi


if [ "$(uname -s)" = 'Darwin' ]; then
    export DISPLAY="$HOSTNAME:0"
fi



export NVM_DIR="$HOME/.nvm"
# shellcheck source=.nvm/nvm.sh
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

# shellcheck source=.nvm/bash_completion
# shellcheck disable=SC1091
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if [ "$TERM" = "linux" ]; then
  set_term_colors
fi

function set_macbook_term_size() {
    add-to-file "stty rows 50" "$HOME/.profile"
    add-to-file "stty columns 160" "$HOME/.profile"
}

bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line

#bindkey '^[[1;5C' forward-word
#bindkey '^[[1;5D' backward-word

[[ "$(tty)" =~ /dev/tty[0-9]* ]] && command -v setupcon &>/dev/null && setupcon
[[ "$(tty)" =~ /dev/tty[0-9]* ]] && [[ "$(hostname)" =~ macbook ]] && set_macbook_term_size


export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor --exclude .mypy-cache'


export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=5
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_PATTERNS

#shellcheck disable=SC2190
# To have commands starting with `rm -rf` in red:
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

# shellcheck source=./.fzf.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v direnv >/dev/null 2>&1
then
	eval "$(direnv hook zsh)"
fi

# https://stackoverflow.com/questions/6429515/stty-hupcl-ixon-ixoff
# Disable CTRL-Z
if [[ -t 0 ]]; then
	stty -ixon -ixoff
fi

# Hook for desk activation
[[ -n "$DESK_ENV" ]] && source "$DESK_ENV"

if [[ -f /usr/share/autojump/autojump.sh ]]; then
    . /usr/share/autojump/autojump.sh
fi
