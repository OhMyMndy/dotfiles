# Dotfiles

`nix run .#just -- switch`

Done :-)


## Build the home-manager image

```bash
podman build -f .devcontainer/Dockerfile -t devcontainer --target home-manager .
```
