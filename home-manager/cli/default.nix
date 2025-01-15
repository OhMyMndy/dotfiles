# see: https://juliu.is/tidying-your-home-with-nix/
{...}: {
  imports = [
    (import ./modules/asdf.nix)
    (import ./modules/audio.nix)
    (import ./modules/bash.nix)
    (import ./modules/cloud.nix)
    (import ./modules/containers.nix)
    (import ./modules/dart.nix)
    (import ./modules/database.nix)
    (import ./modules/distrobox.nix)
    (import ./modules/file-transfer.nix)
    # (import ./modules/fish.nix)
    (import ./modules/git.nix)
    (import ./modules/go.nix)
    (import ./modules/helix.nix)
    (import ./modules/javascript.nix)
    (import ./modules/kubernetes.nix)
    (import ./modules/latex.nix)
    (import ./modules/llm.nix)
    (import ./modules/neovim.nix)
    (import ./modules/networking.nix)
    (import ./modules/nix.nix)
    (import ./modules/performance.nix)
    (import ./modules/python.nix)
    (import ./modules/steampipe.nix)
    (import ./modules/ruby.nix)
    (import ./modules/rust.nix)
    (import ./modules/security.nix)
    (import ./modules/shell.nix)
    (import ./modules/tmux.nix)
    (import ./modules/virtualization.nix)
    # (import ./modules/zellij.nix)
    (import ./modules/zsh.nix)
  ];

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  xdg = {
    enable = true;
    mime.enable = true;
  };
}
