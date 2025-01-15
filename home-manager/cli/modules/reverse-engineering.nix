{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cutter.withPlugins
    (
      ps: with ps; [
        pkgs.cutterPlugins.rz-ghidra
        pkgs.cutterPlugins.sigdb
      ]
    )
  ];
}
