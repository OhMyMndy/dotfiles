
export ZSH=/$HOME/.oh-my-zsh
ZSH_THEME="mandy"
#ZSH_THEME="cypher"
plugins=(git, docker, phpunit, zsh-completions)

source $HOME/.oh-my-zsh/oh-my-zsh.sh
source $HOME/.bash_aliases
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

# precmd () { print -Pn "\e]0;$TITLE\a" }
# precmd () { print -Pn "\e]0;$PROMPT_COMMAND\a" }
# title() { export TITLE="$*" }
echo $TERM
case $TERM in
    *xterm*|rxvt|(dt|k|E)term)
        precmd () {
            print -Pn "\033]0;%n@%m : %~\007"
        }
        preexec () {
            print -Pn "\033]0;%n@%m : <$1>\007"
        }
        ;;
esac
