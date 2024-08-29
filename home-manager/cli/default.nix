# see: https://juliu.is/tidying-your-home-with-nix/
{ pkgs, config, lib, ... }:

{
  imports = [
    (import ./modules/bash.nix)
    (import ./modules/cloud.nix)
    (import ./modules/fish.nix)
    (import ./modules/git.nix)
    (import ./modules/kubernetes.nix)
    (import ./modules/neovim.nix)
    (import ./modules/networking.nix)
    (import ./modules/nix.nix)
    (import ./modules/networking.nix)
    (import ./modules/rbenv.nix)
    (import ./modules/shell.nix)
    (import ./modules/tmux.nix)
    (import ./modules/zellij.nix)
    (import ./modules/zsh.nix)
  ];

  home.username = (builtins.getEnv "USER");
  home.homeDirectory = (builtins.getEnv "HOME");
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  # xdg.enable = true;
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;

  home.packages = with pkgs; [
    nodejs
    python3
  ];
}
