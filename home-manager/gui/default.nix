{ pkgs, ... }:
{
  imports = [
    (import ./../cli)
    (import ./modules/dconf.nix)
    (import ./modules/gnome-extensions.nix)
    (import ./modules/gnome.nix)
    (import ./modules/gtk.nix)
    (import ./modules/i3.nix)
    (import ./modules/wayland.nix)
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    gitkraken
    ibm-plex
    inter
  ];
  home.enableNixpkgsReleaseCheck = false;
  news.display = "silent";
}
