
# shellcheck source=z.zsh
source $HOME/z.sh
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="mandy"

# zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

zstyle ':completion:*' use-cache yes

# shellcheck source=.functions
source $HOME/.functions

detect_os

# Compleat https://limpet.net/mbrubeck/2009/10/30/compleat.html``
# sysadmin-util https://github.com/skx/sysadmin-util

plugins=(git docker docker-compose zsh-completions z zsh-autosuggestions zsh-syntax-highlighting extract jira httpie zsh-peco-history wd colored-man-pages command-not-found cp)

if [ "$OS" = "Ubuntu" ]; then
    plugins+=(debian)
elif [ "$OS" = "Arch Linux" ]; then
    plugins+=(archlinux)
elif [ "$OS" = "Fedora" ]; then
    plugins+=(fedora)
fi


# Autoload zsh commands
autoload -Uz compinit
if [ "$ZSH_COMPDUMP" != '' ] && [[ $(find "$ZSH_COMPDUMP" -mtime +100 -print) ]]; then
	compinit
else
	compinit -C;
fi

if [ -f $HOME/.bash_aliases ]; then
    # shellcheck source=.bash_aliases
    source $HOME/.bash_aliases
fi

if [ -f $HOME/.profile ]; then
    # shellcheck source=.profile
    source $HOME/.profile
fi


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

source ~/.lessrc


export TERMINAL=termite
compctl -g "$HOME/.teamocil/*(:t:r)" teamocil
if exists dircolors; then
    eval "$(dircolors ~/.dircolors)";
fi


export HISTFILE="$HOME/.zhistory"
HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

# precmd () {
#     exec 2>&- >&-
#     lastline=$(tail -1 ~/.command.out)
#     sleep 0.1   # TODO: synchronize better
#     exec > /dev/tty 2>&1
# }
#
# preexec() {
#     exec > >(tee ~/.command.out&)
# }


alias docker-ps-min='docker ps --format "table{{.Names}}\t{{.RunningFor}}\t{{.Status}}"'
alias hl='grepc "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
#alias current-window-process='ps -o args= $(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}") -f _NET_WM_PID 0c " \$0\\n" _NET_WM_PID | awk "{print \$2}")'
alias disk-usage='sudo du -h -t200M -x / 2>/dev/null'
alias xdg-open='exo-open'

# exa aliases
alias dir="exa -lag --git --time-style=long-iso --group-directories-first"
alias dir-sort-size="dir -s=size"
alias dir-sort-size-desc="dir -s=size -r"
alias dir-sort-mod="dir -s=modified"
alias dir-sort-mod-desc="dir -s=modified -r"
alias dir-tree="dir -T -L=2"
alias dir-tree-full="dir -T"


alias rcp='rsync -ah --info progress2'
alias rmv='rsync -ah --info progress2 --remove-sent-files'

if exists thefuck; then eval "$(thefuck --alias)"; fi

if ! exists pbcopy;
then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi


title() {
	print -Pn "\e]0;$1\a"
}


export GOPATH=$HOME/.go
export VISUAL="vim"
export EDITOR='vim'
export TZ='Europe/Brussels'
export DISABLE_AUTO_TITLE=true
export AUTO_TITLE=false
export ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export CHEATCOLORS=true

setup_lsi

if [ "$(uname -s)" != 'Darwin' ]; then
    export SUDO_ASKPASS=/usr/libexec/openssh/gnome-ssh-askpass

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

setupcon 2>/dev/null