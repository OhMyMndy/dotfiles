{
  lib,
  ...
}:
{
   home.activation.setupFlathub = lib.hm.dag.entryAfter [ "installPackages" ] ''
    /usr/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  '';

}
