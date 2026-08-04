{
  pkgs,
  lib,
  config,
  dotfiles,
  ...
}:
{

  home.file.".shellrc.d" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.shellrc.d";
    recursive = true;
  };

  home.file.".profile" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.profile";
  };
}
