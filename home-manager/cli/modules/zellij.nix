{ pkgs, ... }:
{
  home.packages = with pkgs; [ zellij ];

  home.file."./.config/zellij" = {
    source = ./../../../.config/zellij;
    recursive = true;
  };
}
