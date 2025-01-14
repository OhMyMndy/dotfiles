{ pkgs, ... }:
{
  home.packages = with pkgs; [
    texliveMedium
  ];
}
