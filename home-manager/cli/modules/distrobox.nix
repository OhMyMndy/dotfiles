{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [ distrobox ];

  home.activation.setupDistrobox = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # ${pkgs.distrobox}/bin/distrobox create --image docker.io/fedora:41 --name fedora
  '';
}
