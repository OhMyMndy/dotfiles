
export ZSH=/$HOME/.oh-my-zsh
ZSH_THEME="mandy"
#ZSH_THEME="cypher"
plugins=(git, docker, phpunit, zsh-completions)

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

export IP_ADDRESS=$(curl --connect-timeout 1 -s http://whatismyip.akamai.com/)
export GID
export UID

export LOCAL_PROJECT_DIR='/var/www/html/'
export DISABLE_AUTO_TITLE="true"

