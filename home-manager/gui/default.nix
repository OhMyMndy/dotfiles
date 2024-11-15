# SEE https://github.com/redyf/nixdots/blob/492aede6453d4f62fad6929a6281552504efbaa8/home/system/shell/default.nix
# SEE https://home-manager-options.extranix.com/
{ pkgs, ... }:
{
  imports = [
    (import ./../cli)
    (import ./modules/dconf.nix)
    (import ./modules/flatpaks.nix)
    # (import ./modules/gaming.nix)
    (import ./modules/gnome-extensions.nix)
    (import ./modules/gnome.nix)
    (import ./modules/gtk.nix)
    (import ./modules/i3.nix)
    (import ./modules/wayland.nix)
    (import ./modules/x11.nix)
    (import ./modules/zeal.nix)
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
