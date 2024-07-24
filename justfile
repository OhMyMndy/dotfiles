switch:
    nix run .#home-manager -- switch --flake . --impure -b backup

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
