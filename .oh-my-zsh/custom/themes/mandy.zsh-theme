# af-magic.zsh-theme
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

local return_code="%(?..$fg[red]%%? ↵$reset_color%)"
local SEGMENT_SEPARATOR="\ue0b0"

# primary prompt
PROMPT='%{$FG[003]%} %n %{$reset_color%}%{$FG[006]%}@ %{$FG[005]%}%m \
%{$FG[004]%}%~\
$(git_prompt_info) \
%{$FG[002]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\\ $reset_color%'
RPS1='${return_code}'


# color vars
eval my_gray='%{$FG[002]%}'
eval my_orange='%{$FG[004]%}'

# right prompt
RPROMPT='%{$my_gray%}%D{%H:%M:%S}%{$reset_color%}'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[001]%}(%{$FG[001]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[001]%})%{$reset_color%}"
