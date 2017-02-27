
export ZSH=//home/mandy/.oh-my-zsh
ZSH_THEME="af-magic"
plugins=(git, composer, php, docker, phpunit, node)

source /home/mandy/.oh-my-zsh/oh-my-zsh.sh

export PATH=/usr/share/doc/git/contrib/diff-highlight/:$PATH


compinit
_comp_options+=(globdots)
