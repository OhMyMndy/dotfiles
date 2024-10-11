{ pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    quickemu
    cloud-hypervisor
  ];

  home.activation.setupVirtualization = lib.hm.dag.entryAfter [ "installPackages" ] ''
    if getent group kvms &>/dev/null; then
      echo "Setting up KVM for user '$USER'"
      # sudo usermod -aG kvm $USER
    fi
  '';

}