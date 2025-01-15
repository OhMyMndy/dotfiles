{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    duckdb
    sqlite
  ];
}
