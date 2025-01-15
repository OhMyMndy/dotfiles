{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bind # for dig
    nmap
    iputils
    traceroute
  ];
}
