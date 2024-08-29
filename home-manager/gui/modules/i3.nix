{ config, ... }:
{

  home.file.".config/i3" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/i3";
    recursive = true;
  };
}
