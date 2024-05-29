{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
