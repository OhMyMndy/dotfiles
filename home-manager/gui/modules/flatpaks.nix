{ lib, ... }:
{
  home.activation.setupFlathub = lib.hm.dag.entryAfter [ "installPackages" ] ''
    if command -v /usr/bin/flatpak &>/dev/null; then
      /usr/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
  '';

}
