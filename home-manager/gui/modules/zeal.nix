{ config, lib, ... }:
{

  # Install zeal flatpak
  home.activation.setupZeal = lib.hm.dag.entryAfter [ "installPackages" ] ''
    if command -v /usr/bin/flatpak &>/dev/null; then
      /usr/bin/flatpak install --user flathub org.zealdocs.Zeal -y
    fi
  '';

}
