{ pkgs, ... }: {
  imports = [
    (import ./../cli)
    (import ./modules/dconf.nix)
    (import ./modules/gtk.nix)
    (import ./modules/gnome.nix)
    (import ./modules/gnome-extensions.nix)
    (import ./modules/i3.nix)
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    copyq
    gitkraken
    ibm-plex
    inter
  ];
}
