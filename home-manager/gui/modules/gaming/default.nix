{ lib, config, ... }:
{
  home.activation.setupGamingApplications = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH"

    if command -v /usr/bin/flatpak &>/dev/null; then
      /usr/bin/flatpak --user install flathub com.valvesoftware.Steam -y
      /usr/bin/flatpak --user install flathub net.runelite.RuneLite -y
    fi
  '';
}
