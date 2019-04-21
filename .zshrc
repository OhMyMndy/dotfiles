
# shellcheck source=z.zsh
source $HOME/z.sh
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="mandy"
# export ZSH_THEME="robbyrussell"

# zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

#zstyle ':completion:*' use-cache yes

# shellcheck source=.functions
source $HOME/.functions

detect_os

# Compleat https://limpet.net/mbrubeck/2009/10/30/compleat.html``
# sysadmin-util https://github.com/skx/sysadmin-util

plugins=(
    common-aliases
    colored-man-pages
    command-not-found
    cp # This plugin defines a cpv function that uses rsync so that you get the features and security of this command.
    copydir # Copies the path of your current folder to the system clipboard.
    docker
    docker-compose
    extract
    fzf
    git
    httpie
    jira
    kate
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
    plugins+=(debian)
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

if [ -f $HOME/.bash_aliases ]; then
    # shellcheck source=.bash_aliases
    source $HOME/.bash_aliases
fi

if [ -f $HOME/.profile ]; then
    # shellcheck source=.profile
    source $HOME/.profile
fi


zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"


zstyle :omz:plugins:ssh-agent agent-forwarding on

if [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
    # shellcheck source=.oh-my-zsh/oh-my-zsh.sh
    source $HOME/.oh-my-zsh/oh-my-zsh.sh
fi


if [ -f $HOME/bin/commands-to-aliases ]; then
    $HOME/bin/commands-to-aliases > $HOME/.aliases
    # shellcheck source=.aliases
    source $HOME/.aliases
fi

export PATH=$HOME/.config/composer/vendor/bin:$HOME/.composer/vendor/bin:$HOME/.local/bin:/usr/share/doc/git/contrib/diff-highlight:/usr/local/go/bin:$HOME/.go/bin:$HOME/bin:$HOME/bin/appimages:/usr/bin/local:$PATH
PATH="$PATH:$HOME/.gem/bin"

export GEM_HOME=$HOME/.gem
export GEM_PATH=$HOME/.gem

export GOPATH=$HOME/go


if [ -f $HOME/.lessrc ]; then
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

# Prevents local TERM from affecting ssh.
alias ssh='TERM=xterm ssh'

if exists thefuck; then eval "$(thefuck --alias)"; fi

if ! exists pbcopy;
then
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
export AUTO_TITLE=false
export ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export CHEATCOLORS=true


# ssh-agent omzsh should do the same
if [ "$(uname -s)" != 'Darwin' ]; then
    # export SUDO_ASKPASS=/usr/libexec/openssh/gnome-ssh-askpass

    # Launch SSH agent if not running
    if ! ps aux | grep "$(whoami)" | grep ssh-agent | grep -v grep >/dev/null; then ssh-agent ; fi

    # Link the latest ssh-agent socket
    mkdir -p ~/.ssh/
    ln -sf "$(find /tmp -maxdepth 2 -type s -name 'agent*' -user $USER -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2)" ~/.ssh/ssh_auth_sock
    ssh-add -l > /dev/null || ssh-add

    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi

export IP_ADDRESS=$(ip_address)
export HOSTNAME="$(hostname)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function set_term_colors() {
    # echo -en "\e]P01a1b21" #black
    # echo -en "\e]P1ff1835" #darkred
    # echo -en "\e]P231ff7f" #darkgreen
    # echo -en "\e]P3f3ff4d" #brown
    echo -en "\e]P439c2ed" #darkblue
    # echo -en "\e]P5ff68d1" #darkmagenta
    # echo -en "\e]P6169375" #darkcyan
    # echo -en "\e]P7dbdbdb" #lightgrey
    # echo -en "\e]P8959498" #darkgrey
    # echo -en "\e]P9ff1835" #red
    # echo -en "\e]PA31ff7f" #green
    # echo -en "\e]PBf3ff4d" #yellow
    echo -en "\e]PC39c2ed" #blue
    # echo -en "\e]PDff68d1" #magenta
    # echo -en "\e]PE169375" #cyan
    # echo -en "\e]PFffffff" #white

    clear #for background artifacting
}

if [ "$TERM" = "linux" ]; then
  set_term_colors
fi

function set_macbook_term_size() {
    add-to-file "stty rows 50" "$HOME/.profile"
    add-to-file "stty columns 160" "$HOME/.profile"
}
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line
[[ "$(tty)" =~ /dev/tty[0-9]* ]] && setupcon
[[ "$(tty)" =~ /dev/tty[0-9]* ]] && [[ "$(hostname)" =~ macbook ]] && set_macbook_term_size



ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=5

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
