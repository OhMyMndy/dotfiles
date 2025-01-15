{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    # recoll # full-text search tool
  ];
}
