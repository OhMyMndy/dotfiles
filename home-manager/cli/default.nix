# see: https://juliu.is/tidying-your-home-with-nix/
{ ... }:
{
  imports = [
    (import ./minimal.nix)

    (import ./modules/asdf.nix)
    (import ./modules/ansible.nix)
    (import ./modules/audio.nix)
    (import ./modules/bash.nix)
    (import ./modules/sh.nix)
    (import ./modules/cloud.nix)
    (import ./modules/containers.nix)
    (import ./modules/dart.nix)
    (import ./modules/database.nix)
    (import ./modules/distrobox.nix)
    # (import ./modules/fish.nix)
    (import ./modules/go.nix)
    (import ./modules/helix.nix)
    (import ./modules/javascript.nix)
    (import ./modules/kubernetes.nix)
    (import ./modules/latex.nix)
    (import ./modules/llm.nix)
    (import ./modules/neovim.nix)
    (import ./modules/networking.nix)
    (import ./modules/nix.nix)
    (import ./modules/python.nix)
    (import ./modules/steampipe.nix)
    (import ./modules/ruby.nix)
    (import ./modules/rust.nix)
    (import ./modules/virtualization.nix)
    # (import ./modules/zellij.nix)
  ];
}
