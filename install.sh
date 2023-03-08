#!/usr/bin/env bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR" || exit 1

source "$DIR/zsh/.sharedrc" || source "$HOME/.sharedrc" 

if [[ "$TERM" = '' ]]; then
    export TERM=xterm
fi

if ! command -v xstow &>/dev/null; then
    echo "xstow has to be installed!" 1>&2
    exit 0
fi


if ! command -v curl &>/dev/null; then
    echo "curl has to be installed!" 1>&2
    exit 0
fi

if ! command -v git &>/dev/null; then
    echo "git has to be installed!" 1>&2
    exit 0
fi

mkdir -p ~/.bin ~/.local/bin

function install_from_url() {
    local url="$1"
    local name="$2"
    if [[ ! -f ~/.local/bin/"$name" ]] || ! command -v "$name" &>/dev/null; then
        local tmp_output
        tmp_output="$(mktemp)"
        curl -sL -o "$tmp_output" "$url"
        if [[ "$url" == *.xz ]] || [[ "$url" == *.gz ]]; then
            tmp_output="/tmp/$(tar xv --directory=/tmp -f "$tmp_output" --wildcards "*$name")"
        fi
        install -m 0775 "$tmp_output" ~/.local/bin/"$name"
        rm -rf "$tmp_output"
    fi
}

if [[ -f ~/.krew/bin/krew ]]; then
    (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
    )
fi

if [[ ! -d ~/.nvm ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    # load nvm
    source "$DIR/zsh/.sharedrc" || source "$HOME/.sharedrc" 
fi
# install node lts
nvm install --lts
nvm alias default 'lts/*'

if [[ ! -d ~/.tfenv ]]; then
    git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
fi


install_from_url https://github.com/devnw/gvm/releases/download/latest/gvm gvm
# Install a go version
gvm 1.19.6


install_from_url "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" kubectl

install_from_url https://github.com/koalaman/shellcheck/releases/download/v0.9.0/shellcheck-v0.9.0.linux.x86_64.tar.xz shellcheck

install_from_url https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 hadolint


if [[ ! -d ~/.garden/bin ]]; then
    curl -sL https://get.garden.io/install.sh | bash
fi

if [[ ! -d ~/.cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --quiet --no-modify-path -y
fi

if command -v apt-get &>/dev/null; then
    install_from_url https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get deb-get
fi

if ! command -v distrobox; then
   curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local >/dev/null
fi

function do_stow_absolute() {
    xstow -force -absolute-path -restow -target="$HOME" "$1" >/dev/null
}

function do_stow() {
    xstow -force -restow -target="$HOME" "$1" >/dev/null
}



do_stow "$DIR/nixpkgs"

# if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
#     source "$HOME/.nix-profile/etc/profile.d/nix.sh"


#     nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixos-unstable \
#         && nix-channel --update

#     nix-env -iA nixpkgs.ohmymndy-core \
#         && nix-env -iA nixpkgs.ohmymndy-dev \
#         && nix-env -iA nixpkgs.ohmymndy-containers \
#         && nix-env -iA nixpkgs.ohmymndy-diagnostics
# fi

# install_from_url https://github.com/neovim/neovim/releases/download/stable/nvim.appimage nvim

# if [[ ! -d ~/.config/nvim/.git ]]; then
#     git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
# fi

# do_stow "$DIR/nvim"
# linux/macos (unix)
# rm -rf ~/.config/nvim
# rm -rf ~/.local/share/nvim
# rm -rf ~/.cache/nvim



if [[ ! -d ~/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Ohmyzsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi


rm -f ~/.tmux.conf
do_stow "$DIR/tmux"
do_stow "$DIR/vim"
rm -f ~/.zshrc
do_stow "$DIR/zsh"
do_stow "$DIR/polybar"
do_stow "$DIR/i3"
do_stow "$DIR/rofi"


do_stow "$DIR/nvim"


# it doesn't like relative paths...

if [[ -d "$DIR/xfce4-terminal" ]]; then
    do_stow_absolute "$DIR/xfce4-terminal"
fi


if command -v nvim &>/dev/null; then
    echo "Installing nvim packages"
    timeout 60 nvim --headless "+Lazy! sync" +qa || true
    

    timeout 120 nvim -V1 --headless +MasonInstallAll +qa || true
    timeout 60 nvim -V1 --headless +TSUpdate +qa || true
else
    echo "Neovim is not installed, not configuring!" 1>&2
fi


