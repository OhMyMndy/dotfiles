source $HOME/z.sh
export ZSH=/$HOME/.oh-my-zsh
ZSH_THEME="mandy"
plugins=(git, docker, phpunit, zsh-completions, z, zsh-syntax-highlighting, ssh)

if [ -f $HOME/.bash_aliases ]; then
	source $HOME/.bash_aliases
fi

if [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
	source $HOME/.oh-my-zsh/oh-my-zsh.sh
fi
export PATH=$HOME/bin:$HOME/.local/bin:/usr/share/doc/git/contrib/diff-highlight/:$PATH

if [ -f $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

export HISTFILE="$HOME/.zhistory"
HISTSIZE=100000
SAVEHIST=100000

# Allow autocompletion for dot files/folders
compinit
_comp_options+=(globdots)

# Prevent Git from:
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
alias git='LC_ALL=C git' 


grepc()
{
  pattern=$1
  shift
  if [ ! -z $2 ]; then
    esc=$(printf "\0\$2")
    shift
  else
    esc=$(printf "\033")
  fi
  sed -E 's"'"$pattern"'"'$esc'[32m&'$esc'[0m"g' "$@"
}

alias hl='grepc "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
alias find="find \$@ 2>/dev/null"
alias current-window-process='ps -o args= $(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}") -f _NET_WM_PID 0c " \$0\\n" _NET_WM_PID | awk "{print \$2}")'
histcmd() {
fc -l 1 |  awk '{line=$1; $1=""; CMD_LINE[$0]=line; CMD[$0]++;count++; for (a in CMD)print CMD[a] " " CMD_LINE[a] " " a;}' | sort -rn 
}

precmd () { print -Pn "\e]0;$TITLE\a" }
title() { export TITLE="$*" }

export VISUAL="vim"
export EDITOR='vim'
export IP_ADDRESS=$(ip -4 route get 1 | head -1 | cut -d' ' -f7)
export GID=$(id -g)
export UID=$(id -u)
export TZ='Europe/Brussels'
export LOCAL_PROJECT_DIR='/var/www/html/'
export DISABLE_AUTO_TITLE="true"
export AUTO_TITLE=false
export CHROMIUM_PORT=5910


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/mandy/.sdkman"
[[ -s "/home/mandy/.sdkman/bin/sdkman-init.sh" ]] && source "/home/mandy/.sdkman/bin/sdkman-init.sh"
