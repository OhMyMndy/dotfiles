if [[ -f /etc/zshrc ]]; then
  source /etc/zshrc
fi


# bindkey "^[[H" beginning-of-line
# bindkey "^[[F" end-of-line
# Make ctrl+backpace and ctrl+delete work in zsh
# bindkey '^H' backward-kill-word
# bindkey '5~' kill-word
    #   bindkey  "^[OH"   beginning-of-line
    #   bindkey  "^[OF"   end-of-line

    #   bindkey  "^[[1~"   beginning-of-line
    #   bindkey  "^[[4~"   end-of-line



# shellcheck disable=SC2076
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

setopt rmstarsilent

# prevent bell
bindkey -e


# fix Alt + Left/Right on Linux
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word   

#   # see: https://stackoverflow.com/questions/18600188/home-end-keys-do-not-work-in-tmux
#   bindkey  "^[OH"   beginning-of-line
#   bindkey  "^[OF"   end-of-line

#   bindkey  "^[[1~"   beginning-of-line
#   bindkey  "^[[4~"   end-of-line


#shellcheck disable=SC2190
# To have commands starting with `rm -rf` in red:

# https://stackoverflow.com/questions/6429515/stty-hupcl-ixon-ixoff
# Disable CTRL-Z
# if [[ -t 0 ]]; then
#     stty -ixon -ixoff
# fi


# SEE https://github.com/catppuccin/fzf
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
# --color=selected-bg:#45475a \
# --multi"

if [[ -d ~/.shellrc.d ]]; then
  for rc in ~/.shellrc.d/*(DN); do
    if [[ -f "$rc" ]]; then
        # shellcheck disable=SC1090
        . "$rc"
    fi
    done
fi

if [[ -d ~/.zshrc.d ]]; then
  for rc in ~/.zshrc.d/*(DN); do
    if [[ -f "$rc" ]]; then
        # shellcheck disable=SC1090
        . "$rc"
    fi
  done
fi

# SEE: https://discourse.nixos.org/t/nix-shell-does-not-use-my-users-shell-zsh/5588/12
nix() {
  if [[ $1 == "develop" ]]; then
    shift
    command nix develop -c $SHELL "$@"
  else
    command nix "$@"
  fi
}
