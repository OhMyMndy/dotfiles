export SHELL=zsh
source $HOME/z.sh
source $HOME/.functions

export ZSH=/$HOME/.oh-my-zsh

ZSH_THEME="mandy"
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
plugins=(git, docker, phpunit, zsh-completions, z, zsh-syntax-highlighting, node, extract)

autoload -U compinit && compinit
if [ -f $HOME/.bash_aliases ]; then
	source $HOME/.bash_aliases
fi

if [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
	source $HOME/.oh-my-zsh/oh-my-zsh.sh
fi
export PATH=$HOME/bin:$HOME/.config/composer/vendor/bin:$HOME/.composer/vendor/bin:$HOME/.local/bin:/usr/share/doc/git/contrib/diff-highlight:/usr/local/go/bin:$HOME/.go/bin:$PATH

if [ -f $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting  ]; then
	source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 
fi

compctl -g '~/.teamocil/*(:t:r)' teamocil

if [ -d ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
fi

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



alias hl='grepc "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
alias find="find \$@ 2>/dev/null"
alias current-window-process='ps -o args= $(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}") -f _NET_WM_PID 0c " \$0\\n" _NET_WM_PID | awk "{print \$2}")'
histcmd() {
fc -l 1 |  awk '{line=$1; $1=""; CMD_LINE[$0]=line; CMD[$0]++;count++; for (a in CMD)print CMD[a] " " CMD_LINE[a] " " a;}' | sort -rn 
}
alias git-https-to-ssh='sed -E -i "s/https:\/\/github\.com\//git@github\.com:/"
'
if exists thefuck; then
    eval $(thefuck --alias)
fi

if ! exists pbcopy; then
    if exists xsel; then
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
    elif exists termux-clipboard-get; then
        alias pbcopy='termux-clipboard-set'
        alias pbpaste='termux-clipboard-get'
    fi

fi


export GOPATH=$HOME/.go
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export VISUAL="vim"
export EDITOR='vim'
export IP_ADDRESS=$(ip -4 route get 1 | awk '{split($5,a,"/");print a[1]}' )
export GID=$(id -g)
export UID=$(id -u)
export TZ='Europe/Brussels'
export LOCAL_PROJECT_DIR='/var/www/html/'
export DISABLE_AUTO_TITLE="false"
export AUTO_TITLE=true
export CHROMIUM_PORT=5910
export OS=$(lsb_release -si)
export ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
export OS_VER=$(lsb_release -sr)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/mandy/.sdkman"
[[ -s "~/.sdkman/bin/sdkman-init.sh" ]] && source "~/.sdkman/bin/sdkman-init.sh"
[[ -s "~/.fresh/build/shell.sh" ]] && source "~/.fresh/build/shell.sh" 
