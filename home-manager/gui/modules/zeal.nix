{
  config,
  lib,
  ...
}: {
  # Install zeal flatpak
  home.activation.setupZeal = lib.hm.dag.entryAfter ["installPackages"] ''
    # add path here so flatpak can access other binaries
    PATH="${config.home.path}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH"
    if command -v /usr/bin/flatpak &>/dev/null; then
      /usr/bin/flatpak --user install flathub org.zealdocs.Zeal -y
    fi
  '';
}
