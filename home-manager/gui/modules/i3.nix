{ config, dotfiles, ... }:
{
  # home.file.".config/i3".source =
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/i3";
}
