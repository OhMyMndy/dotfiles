{ pkgs, ... }:
{
  home.packages = with pkgs; [
    act
    distrobox
    hadolint
  ];
}
