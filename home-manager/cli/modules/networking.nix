{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bind # for dig
    iputils
    traceroute
  ];
}
