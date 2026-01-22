{ ... }:
{
  imports = [
    (import ../cli/minimal.nix)
    (import ../gui/minimal.nix)

    (import ../cli/modules/cloud.nix)
    (import ../cli/modules/containers.nix)

    (import ../cli/modules/neovim.nix)
  ];

}
