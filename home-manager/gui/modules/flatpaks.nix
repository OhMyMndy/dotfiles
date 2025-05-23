{ lib, config, ... }:
{

  # TODO: install flatpak install flathub io.github.jonmagon.kdiskmark
  home.activation.setupFlathub = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # add path here so flatpak can access other binaries
    PATH="${config.home.path}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH"
    if command -v /usr/bin/flatpak &>/dev/null; then
      mkdir -p ~/.local/share/flatpak/repo/refs/remotes/ ~/.local/share/flatpak/repo/refs/heads/
      /usr/bin/flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
  '';
}
