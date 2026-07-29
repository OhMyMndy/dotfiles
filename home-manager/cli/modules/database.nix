{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    atlas
    duckdb
    sqlite
  ];
}
