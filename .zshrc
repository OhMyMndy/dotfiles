source /etc/zshrc

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
# Make ctrl+backpace and ctrl+delete work in zsh
bindkey '^H' backward-kill-word
bindkey '5~' kill-word
    #   bindkey  "^[OH"   beginning-of-line
    #   bindkey  "^[OF"   end-of-line

    #   bindkey  "^[[1~"   beginning-of-line
    #   bindkey  "^[[4~"   end-of-line
# bindkey -e
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word    
#shellcheck disable=SC2190
# To have commands starting with `rm -rf` in red:

# https://stackoverflow.com/questions/6429515/stty-hupcl-ixon-ixoff
# Disable CTRL-Z
# if [[ -t 0 ]]; then
#     stty -ixon -ixoff
# fi
#
