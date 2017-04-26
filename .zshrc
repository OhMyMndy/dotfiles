source $HOME/z.sh
export ZSH=/$HOME/.oh-my-zsh
ZSH_THEME="mandy"
#ZSH_THEME="cypher"
plugins=(git, docker, phpunit, zsh-completions, z)

if [ -f $HOME/.bash_aliases ]; then
	source $HOME/.bash_aliases
fi

if [ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]; then
	source $HOME/.oh-my-zsh/oh-my-zsh.sh
fi
export PATH=/usr/share/doc/git/contrib/diff-highlight/:$PATH

# Allow autocompletion for dot files/folders
compinit
_comp_options+=(globdots)

# Prevent Git from:
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
alias git='LC_ALL=C git' 


precmd () { print -Pn "\e]0;$TITLE\a" }
title() { export TITLE="$*" }
DISABLE_AUTO_TITLE="true"


export VISUAL="vim"

export IP_ADDRESS=$(ip -4 route get 1 | head -1 | cut -d' ' -f7)
export GID
export UID
export TZ='Europe/Brussels'
export LOCAL_PROJECT_DIR='/var/www/html/'
export DISABLE_AUTO_TITLE="true"

