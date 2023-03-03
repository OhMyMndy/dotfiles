#!/usr/bin/env bash

./install.sh

# if [[ -f /etc/fuse.conf ]]; then
#     sudo sed -i -E 's/#(user_allow_other)/\1/' /etc/fuse.conf
# fi


# if ! mountpoint -q ~/docker-volumes; then
#   mkdir -p ~/docker-volumes
#   bindfs --force-user="$(id -u)" --force-group="$(id -g)" ~/docker-volumes ~/docker-volumes
# fi


if [[ -d /workspaces/dotfiles ]]; then
  mv /home/vscode/dotfiles /home/vscode/dotfiles_
  ln -sf /workspaces/dotfiles /home/vscode/dotfiles
fi

if [[ -d ~vscode/.ssh ]]; then
  sudo chown vscode:vscode -R ~vscode/.ssh
  sudo chmod 700 ~vscode/.ssh
  chmod 600 ~/.ssh/config || true
  chmod 600 ~/.ssh/id_* || true
  chmod 644 ~/.ssh/*.pub || true
fi


# Status 2 means error connecting to agent
if ! ssh-add -l 2>/dev/null; then
    eval "$(ssh-agent)"
fi

exec "$@"