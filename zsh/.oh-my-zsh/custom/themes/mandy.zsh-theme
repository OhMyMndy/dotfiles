# af-magic.zsh-theme
# Repo: https://github.com/andyfleming/oh-my-zsh
# Direct Link: https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

local return_code="%(?..[%?] )"
local SEGMENT_SEPARATOR="\ue0b0"

# primary prompt
PROMPT='%{$fg[white]%} %n%{$reset_color%}%{$FG[202]%} @ %{$FG[248]%}%m \
%{$fg[cyan]%}%~\
$(git_prompt_info) \
%{$fg[white]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[202]%}\\ $reset_color%'
RPROMPT='${return_code}'

if [[ $COLUMNS -gt 47 ]]; then
    # right prompt
    RPROMPT+='%{$fg[white]%}%D{%H}%{$reset_color%}'
    RPROMPT+='%{$fg[white]%}%D{:%M:}%{$reset_color%}'
    RPROMPT+='%{$fg[white]%}%D{%S}%{$reset_color%}'

    # RPROMPT+='%{$fg[white]%}%D{%H}%{$reset_color%}'
    # RPROMPT+='%{$fg[yellow]%}%D{:%M:}%{$reset_color%}'
    # RPROMPT+='%{$fg[blue]%}%D{%S}%{$reset_color%}'
fi

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}(%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[202]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[white]%})%{$reset_color%}"
