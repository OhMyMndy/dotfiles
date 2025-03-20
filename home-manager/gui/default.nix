# SEE https://github.com/redyf/nixdots/blob/492aede6453d4f62fad6929a6281552504efbaa8/home/system/shell/default.nix
# SEE https://home-manager-options.extranix.com/
{ pkgs, ... }:
{
  imports = [
    (import ./../cli)
    (import ./minimal.nix)
    (import ./modules/alacritty.nix)
    (import ./modules/flatpaks.nix)
    (import ./modules/gaming)
    (import ./modules/i3.nix)
    (import ./modules/zeal.nix)
  ];

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ibm-plex
    inter
  ];

}
