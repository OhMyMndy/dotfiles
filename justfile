set shell := ["bash", "-c"]

switch:
    if [[ -n "$DISPLAY" ]]; then nix run .#home-manager -- switch --flake .#gui --impure -b backup; fi
    if [[ -z "$DISPLAY" ]]; then nix run .#home-manager -- switch --flake .#cli --impure -b backup; fi

switch-gui:
    nix run .#home-manager -- switch --flake .#gui --impure -b backup

switch-cli:
    nix run .#home-manager -- switch --flake .#cli --impure -b backup
format:
    nix run .#nixpkgs-fmt -- .

update:
    nix flake update

clean:
    nix-collect-garbage -d

update-bashrc:
    podman run docker://rockylinux:9 bash -c "cat /etc/skel/.bashrc" > .bashrc
    podman run docker://rockylinux:9 bash -c "cat /etc/skel/.bash_profile" > .bash_profile


clear-nvim:
    rm -rf ~/.cache/nvim ~/.local/share/nvim 

remove-lazy-lock:
    rm .config/nvim/lazy-lock.json || true

add-lazy-lock:
    cp ~/.config/nvim/lazy-lock.json .config/nvim/
    git add .config/nvim/lazy-lock.json
