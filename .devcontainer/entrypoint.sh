#!/usr/bin/env bash


# see: https://discourse.nixos.org/t/github-codespace-support/27152/3
sudo chmod 1777 /tmp/
sudo setfacl  --remove-default  /tmp

if [[ -d ~vscode/.ssh ]]; then
  sudo chown vscode:vscode -R ~vscode/.ssh
  sudo chmod 700 ~vscode/.ssh
  chmod 600 ~/.ssh/config || true
  chmod 600 ~/.ssh/id_* || true
  chmod 644 ~/.ssh/*.pub || true
fi


# Status 2 means error connecting to agent
# if ! ssh-add -l 2>/dev/null; then
#     eval "$(ssh-agent)"
# fi

if command -v podman &>/dev/null; then
    sudo "$(which podman)" image trust set -t reject default
    sudo "$(which podman)" image trust set --type accept docker.io
    sudo "$(which podman)" image trust set --type accept mcr.microsoft.com

fi


exec "$@"