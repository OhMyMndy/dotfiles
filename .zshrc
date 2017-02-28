
export ZSH=//home/mandy/.oh-my-zsh
ZSH_THEME="af-magic"
plugins=(git, composer, php, docker, phpunit, node)

source /home/mandy/.oh-my-zsh/oh-my-zsh.sh

export PATH=/usr/share/doc/git/contrib/diff-highlight/:$PATH

# Allow autocompletion for dot files/folders
compinit
_comp_options+=(globdots)

# Prevent Git from:
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
alias git='LC_ALL=C git' 

