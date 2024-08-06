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
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:

        let stable-pkgs = import nixpkgs {config.allowUnfree = true; system = system; }; 
        unstable-pkgs = import nixpkgs-unstable {config.allowUnfree = true; system = system; }; 
        pkgs = stable-pkgs // {
          # provides alias for all unstable pkgs SEE: https://rexk.github.io/en/blog/nix-home-manager-flake-setup/
          unstable = unstable-pkgs;
          neovim = unstable-pkgs.neovim;
          neovim-unwrapped = unstable-pkgs.neovim-unwrapped;
        };
      in
        {
          apps = rec {
            home-manager = flake-utils.lib.mkApp { drv = pkgs.home-manager; };
            just = flake-utils.lib.mkApp { drv = pkgs.just; };
            nixpkgs-fmt = flake-utils.lib.mkApp { drv = pkgs.nixpkgs-fmt; };
          };

        packages = {
      homeConfigurations = {
        "vscode" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "vscode";
          };
        };
        "mandy" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "mandy";
          };
        };
        "cloud_shell" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "mandy_schoep";
          };
        };
        "mschoep" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-cli.nix ];
          extraSpecialArgs = {
            username = "mschoep";
          };
        };
        "gui" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home-cli.nix ./home-gui.nix ];
          extraSpecialArgs = {
            inherit pkgs;
            username = "mandy";
          };
        };
      };
        };
    });

}
