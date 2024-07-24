{
  description = "My Home Manager Flake";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          apps = rec {
            home-manager = flake-utils.lib.mkApp { drv = pkgs.home-manager; };
            just = flake-utils.lib.mkApp { drv = pkgs.just; };
            nixpkgs-fmt = flake-utils.lib.mkApp { drv = pkgs.nixpkgs-fmt; };
          };
        }
      ) //
    {
      homeConfigurations = {
        "vscode" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "vscode";
          };
        };
        "mandy" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "mandy";
          };
        };
        "cloud_shell" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "mandy_schoep";
          };
        };
        "mschoep" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "mschoep";
          };
        };
        "gui" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home-cli.nix ./home-gui.nix ];
          extraSpecialArgs = {
            username = "mandy";
          };
        };
      };
    };
}
