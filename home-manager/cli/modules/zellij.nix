{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    zellij
  ];

  home.file."./.config/zellij" = {
    source = config.lib.file.mkOutOfStoreSymlink ./../../../.config/zellij;
    recursive = true;
  };
}
