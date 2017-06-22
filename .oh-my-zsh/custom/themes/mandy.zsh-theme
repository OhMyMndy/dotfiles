# af-magic.zsh-theme
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..$fg[red]%%? ↵$reset_color%)"
local SEGMENT_SEPARATOR="\ue0b0"

# primary prompt
PROMPT='$FG[237]------------------------------------------------------------%{$reset_color%}
%{$FG[027]%} %n %{$reset_color%}%{$FG[208]%}@%{$FG[200]%}%m \
%{$fg[cyan]%}%~\
$(git_prompt_info) \
%{$fg[cyan]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\\ $reset_color%'
RPS1='${return_code}'


# color vars
eval my_gray='%{$fg[green]%}'
eval my_orange='%{$fg[red]%}'

# right prompt
RPROMPT='%{$my_gray%}%D{%L:%M:%S}%{$reset_color%}'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%})%{$reset_color%}"
