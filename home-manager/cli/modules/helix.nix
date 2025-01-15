{
  pkgs,
  lib,
  home,
  ...
}:
{
  home.packages = with pkgs; [
    helix # helix editor
  ];
}
