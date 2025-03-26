{ pkgs, ... }:
{
  home.packages = with pkgs; [
    atop
    btop
    htop
  ];
}
