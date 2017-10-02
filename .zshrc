source $HOME/z.sh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="mandy"

source $HOME/.functions

detect_os

# Compleat https://limpet.net/mbrubeck/2009/10/30/compleat.html``
# sysadmin-util https://github.com/skx/sysadmin-util
plugins=(git docker zsh-completions z zsh-autosuggestions zsh-syntax-highlighting extract common-aliases jira httpie zsh-peco-history sysadmin-util)

if [ "$OS" = "Ubuntu" ]; then
    plugins+=(debian)
elif [ "$OS" = "Arch Linux" ]; then
    plugins+=(archlinux)
fi


# Autoload zsh commands
autoload -Uz compinit
if [ "$ZSH_COMPDUMP" != '' ] && [[ $(find "$ZSH_COMPDUMP" -mtime +100 -print) ]]; then
	compinit
else
	compinit -C;
fi

if [ -f $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi


if [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
    source $HOME/.oh-my-zsh/oh-my-zsh.sh
fi


if [ -f $HOME/bin/commands-to-aliases ]; then
    $HOME/bin/commands-to-aliases > $HOME/.aliases
    source $HOME/.aliases
fi


export PATH=$HOME/bin:$HOME/.config/composer/vendor/bin:$HOME/.composer/vendor/bin:$HOME/.local/bin:/usr/share/doc/git/contrib/diff-highlight:/usr/local/go/bin:$HOME/.go/bin:$PATH

compctl -g '~/.teamocil/*(:t:r)' teamocil
if [ "$(command_exists 'dircolors')" = 0 ]; then eval "$(dircolors ~/.dircolors)";  fi
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


export HISTFILE="$HOME/.zhistory"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
# Allow autocompletion for dot files/folders
#_comp_options+=(globdots)

# Prevent Git from:
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
#alias git='LC_ALL=C git'




alias docker-ps-min='docker ps --format "table{{.Names}}\t{{.RunningFor}}\t{{.Status}}"'
alias hl='grepc "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
alias find="find \$@ 2>/dev/null"
alias current-window-process='ps -o args= $(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}") -f _NET_WM_PID 0c " \$0\\n" _NET_WM_PID | awk "{print \$2}")'
alias disk-usage='sudo du -h -t200M -x / 2>/dev/null'


if [ "$(command_exists 'thefuck')" = 0 ]; then eval $(thefuck --alias); fi

if [ "$(command_exists 'pbcopy')" = 0 ];
then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi


title() {
	print -Pn "\e]0;$1\a"
}


export GOPATH=$HOME/.go
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export VISUAL="vim"
export EDITOR='vim'
export IP_ADDRESS=$(ip -4 route get 1 | head -1 | awk '{print $7}' )
export GID=$(id -g)
export UID=$(id -u)
export TZ='Europe/Brussels'
export DISABLE_AUTO_TITLE="false"
export AUTO_TITLE=true
export CHROMIUM_PORT=5910
export ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

export CHEATCOLORS=true


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/mandy/.sdkman"
[[ -s "~/.sdkman/bin/sdkman-init.sh" ]] && source "~/.sdkman/bin/sdkman-init.sh"


setup_lsi


#alias fixssh='eval $(tmux show-env -s |grep "^SSH_")'

#fixssh

# Launch SSH agent if not running
if ! ps aux |grep $(whoami) |grep ssh-agent |grep -v grep >/dev/null; then ssh-agent ; fi

# Link the latest ssh-agent socket
ln -sf $(find /tmp -maxdepth 2 -type s -name "agent*" -user $USER -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2) ~/.ssh/ssh_auth_sock

export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock


export LOCAL_DOCKER_DIR='/var/www/docker/'
export LOCAL_PHING_DIR='/var/www/phing/'
export LOCAL_PROJECT_DIR='/var/www/html/'