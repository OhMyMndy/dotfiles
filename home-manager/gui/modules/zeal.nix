{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [

  ];

  # Install zeal flatpak
  home.activation.setupZeal = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH"
    flatpak install flathub org.zealdocs.Zeal -y
  '';

}
