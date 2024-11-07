set shell := ["bash", "-c"]

switch:
    if [[ -n "$DISPLAY" ]]; then time nix run .#home-manager -- switch --flake .#gui --impure -b backup; fi
    if [[ -z "$DISPLAY" ]]; then time nix run .#home-manager -- switch --flake .#cli --impure -b backup; fi

switch-gui:
    time nix run .#home-manager -- switch --flake .#gui --impure -b backup

switch-cli:
    time nix run .#home-manager -- switch --flake .#cli --impure -b backup

format:
    time nix run nixpkgs#nixfmt-rfc-style -- --strict .

update:
    time nix flake update

clean:
    time nix-collect-garbage -d

update-bashrc:
    podman run --rm docker://rockylinux:9 bash -c "cat /etc/skel/.bashrc" > .bashrc
    podman run --rm docker://rockylinux:9 bash -c "cat /etc/skel/.bash_profile" > .bash_profile

clear-nvim:
    rm -rf ~/.cache/nvim ~/.local/share/nvim ~/.local/state/nvim

remove-lazy-lock:
    rm .config/nvim/lazy-lock.json || true

add-lazy-lock:
    cp ~/.config/nvim/lazy-lock.json .config/nvim/
    git add .config/nvim/lazy-lock.json

update-flathub-list:
    flatpak list --columns "origin,application" --app | grep flathub > flatpak.flathub.txt

install-flathub-flatpaks:
     cat flatpak.flathub.txt | tr '\n' '\0' | xargs -0 -r -I{} bash -c 'flatpak install -y {}'
