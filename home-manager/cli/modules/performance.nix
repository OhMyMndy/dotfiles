{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      htop
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      atop
      btop
    ];
}
