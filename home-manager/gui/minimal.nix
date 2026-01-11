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
}
