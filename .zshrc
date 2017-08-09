source $HOME/z.sh
export ZSH=/$HOME/.oh-my-zsh
ZSH_THEME="mandy"
plugins=(git, docker, phpunit, zsh-completions, z, zsh-syntax-highlighting, node, extract)
autoload -U compinit && compinit
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

if [ -f $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting  ]; then
	source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 
fi
compctl -g '~/.teamocil/*(:t:r)' teamocil
eval "$(dircolors ~/.dircolors)"
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

alias docker-ps-min='docker ps --format "table{{.Names}}\t{{.RunningFor}}\t{{.Status}}"'
alias hl='grepc "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"'
alias find="find \$@ 2>/dev/null"
alias current-window-process='ps -o args= $(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}") -f _NET_WM_PID 0c " \$0\\n" _NET_WM_PID | awk "{print \$2}")'
histcmd() {
fc -l 1 |  awk '{line=$1; $1=""; CMD_LINE[$0]=line; CMD[$0]++;count++; for (a in CMD)print CMD[a] " " CMD_LINE[a] " " a;}' | sort -rn 
}
eval $(thefuck --alias) 

which pbcopy 2>&1 > /dev/null
local pbcopyNotExists=$?
if [ "${pbcopyNotExists}" = "1" ];
then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
fi


# precmd () { print -Pn "\e]0;$TITLE\a" }
title() {
	print -Pn "\e]0;$1\a" 
}


# @see https://github.com/kepkin/dev-shell-essentials/blob/master/highlight.sh
function highlight() {
	declare -A fg_color_map
	fg_color_map[black]=30
	fg_color_map[red]=31
	fg_color_map[green]=32
	fg_color_map[yellow]=33
	fg_color_map[blue]=34
	fg_color_map[magenta]=35
	fg_color_map[cyan]=36
	 
	fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
	c_rs=$'\e[0m'
	sed -u s"/$2/$fg_c\0$c_rs/g"
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

which ls-i 2>&1 > /dev/null
local lsINotExists=$?
if [ "${lsINotExists}" = "0" ];
then
	LS_COLORS=$(ls_colors_generator)

	run_ls() {
		ls-i --color=auto -w $(tput cols) "$@"
	}

	run_dir() {
		dir-i --color=auto -w $(tput cols) "$@"
	}

	run_vdir() {
		vdir-i --color=auto -w $(tput cols) "$@"
	}
	alias ls="run_ls"
	alias dir="run_dir"
	alias vdir="run_vdir"/
fi
