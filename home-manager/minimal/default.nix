{ ... }:
{
  imports = [
    # (import ../cli/modules/asdf.nix)
    # (import ../cli/modules/audio.nix)
    (import ../cli/modules/bash.nix)
    (import ../cli/modules/cloud.nix)
    (import ../cli/modules/containers.nix)
    # (import ../cli/modules/dart.nix)
    # (import ../cli/modules/database.nix)
    # (import ../cli/modules/distrobox.nix)
    (import ../cli/modules/file-transfer.nix)
    # (import ../cli/modules/fish.nix)
    (import ../cli/modules/git.nix)
    # (import ../cli/modules/go.nix)
    # (import ../cli/modules/javascript.nix)
    (import ../cli/modules/kubernetes.nix)
    # (import ../cli/modules/llm.nix)
    (import ../cli/modules/neovim.nix)
    (import ../cli/modules/networking.nix)
    # (import ../cli/modules/nix.nix)
    # (import ../cli/modules/performance.nix)
    # (import ../cli/modules/python.nix)
    # (import ../cli/modules/steampipe.nix)
    # (import ../cli/modules/ruby.nix)
    # (import ../cli/modules/rust.nix)
    # (import ../cli/modules/security.nix)
    (import ../cli/modules/shell.nix)
    (import ../cli/modules/tmux.nix)
    # (import ../cli/modules/virtualization.nix)
    # (import ../cli/modules/zellij.nix)
    (import ../cli/modules/zsh.nix)
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
