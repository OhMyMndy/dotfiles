{ pkgs, lib, config, dotfiles, ... }:
{
  home.packages = with pkgs; [
  ];

  home.file.".ssh/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.ssh/config";
}
