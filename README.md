# Dotfiles

## Getting started

`nix run .#just -- gh-login`

`nix run .#just -- bw-config bw-login`
`export BW_SESSION="$(nix run .#just -- bw-unlock)"`
`nix run .#just -- switch`

Done :-)

## Build the home-manager image

```bash
podman build -f .devcontainer/Dockerfile -t devcontainer --target home-manager .
```


## Handy Nix commands

`nix run nixpkgs#fresh -- --version`

## Test in docker

```
docker run --rm -it fedora:43
```