{ pkgs, ... }:
{
  imports = [
    (import ../base.nix)
    (import ./modules/dconf.nix)
    (import ./modules/gnome-extensions.nix)
    (import ./modules/gnome.nix)
    (import ./modules/gtk.nix)
    (import ./modules/wayland.nix)
    (import ./modules/x11.nix)
  ];


  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ibm-plex
    inter
  ];

}
