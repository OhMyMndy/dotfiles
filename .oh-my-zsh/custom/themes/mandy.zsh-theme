# af-magic.zsh-theme
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..$fg[red]%%? ↵$reset_color%)"
local SEGMENT_SEPARATOR="\ue0b0"

# primary prompt
PROMPT='$FG[237]------------------------------------------------------------%{$reset_color%}
%{$FG[154]%} %n %{$reset_color%}%{$FG[208]%}@ %{$FG[171]%}%m \
%{$FG[117]%}%~\
$(git_prompt_info) \
%{$FG[117]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\\ $reset_color%'
RPS1='${return_code}'


# color vars
eval my_gray='%{$FG[154]%}'
eval my_orange='%{$fg[red]%}'

# right prompt
RPROMPT='%{$my_gray%}%D{%L:%M:%S}%{$reset_color%}'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[154]%}(%{$FG[154]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[154]%})%{$reset_color%}"
