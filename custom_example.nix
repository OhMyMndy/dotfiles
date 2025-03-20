{...}: {
  imports = [
    (import ./home-manager/cli/minimal.nix)
    (import ./home-manager/gui/minimal.nix)

    (import ./home-manager/cli/modules/cloud.nix)
    (import ./home-manager/cli/modules/containers.nix)
    (import ./home-manager/cli/modules/dart.nix)
    (import ./home-manager/cli/modules/kubernetes.nix)
    (import ./home-manager/cli/modules/neovim.nix)
    (import ./home-manager/cli/modules/networking.nix)
    (import ./home-manager/cli/modules/steampipe.nix)
  ];

}
