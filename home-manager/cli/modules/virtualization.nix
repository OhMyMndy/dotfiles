{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # cloud-hypervisor
    # quickemu
    virter
  ];

  home.activation.setupVirtualization = lib.hm.dag.entryAfter ["installPackages"] ''
    if getent group kvms &>/dev/null; then
      echo "Setting up KVM for user '$USER'"
      # sudo usermod -aG kvm $USER
    fi

  '';

  home.activation.setupVirter = lib.hm.dag.entryAfter ["installPackages"] ''
    mkdir -p ~/.ssh/
    touch ~/.ssh/config

    if ! grep -q virter ~/.ssh/config; then

    cat <<EOF | tee -a ~/.ssh/config
    Match exec "virter vm exists %h"
      User root
      IdentityAgent none
      IdentityFile ~/.config/virter/id_rsa
      KnownHostsCommand /usr/bin/env virter vm host-key %n
    EOF

    fi
    # ${pkgs.virter}/bin/virter vm pull alma-9
  '';
}
