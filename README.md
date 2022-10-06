# Dotfiles

## Ubuntu

```bash
sudo apt-get update -qq; sudo apt-get install git vim curl jq -y -qq
cd ~
git clone -q https://github.com/mandy91/dotfiles.git

~/dotfiles/install.sh
```

## Termux

```bash
apt install openssh zsh git vim tmux wget curl ruby -y
cd ~
git clone -q https://github.com/mandy91/dotfiles.git
```

### OCI container image

```bash
docker run --rm -it -p 8083:8083 \
    --workdir /home/vscode \
    --mount "source=$HOME/src,target=/home/vscode/src,type=bind" \
    --mount "source=$HOME/.ssh,target=/home/vscode/.ssh,type=bind" \
    --cap-add=SYS_ADMIN --device=/dev/fuse \
    --privileged ohmymndy/dotfiles:latest
```

Run i3 with novnc on port 8083
`.devcontainer/entrypoint-i3.sh sleep infinity`