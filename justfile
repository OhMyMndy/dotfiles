switch:
    nix run .#home-manager -- switch --flake . --impure -b backup

clean:
    nix-collect-garbage -d

update-bashrc:
    podman run docker://rockylinux:9 bash -c "cat /etc/skel/.bashrc" > .bashrc
    podman run docker://rockylinux:9 bash -c "cat /etc/skel/.bash_profile" > .bash_profile