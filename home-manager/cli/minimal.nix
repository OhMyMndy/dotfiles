{ pkgs, ... }:
{
  imports = [
    (import ../base.nix)
  ]
  ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    (import ../base_linux.nix)
  ]
  ++ [
    (import ./modules/bash.nix)
    (import ./modules/sh.nix)
    (import ./modules/ansible.nix)
    (import ./modules/file-transfer.nix)
    (import ./modules/git.nix)
    (import ./modules/performance.nix)
    (import ./modules/security.nix)
    (import ./modules/shell.nix)
    (import ./modules/ssh.nix)
    (import ./modules/tmux.nix)
    (import ./modules/zsh.nix)
  ];

}
