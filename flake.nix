{
  description = "OhMyMndy's Dotfiles!";
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-previous.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
    nix-rice = {
      url = "github:bertof/nix-rice";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11"; # release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-previous,
      nixpkgs-unstable,
      nixpkgs-master,
      nixpkgs-staging,
      home-manager,
      flake-utils,
      nix-rice,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ nix-rice.overlays.default ];
        stable-pkgs = import nixpkgs {
          config.allowUnfree = true;
          inherit system;
          inherit overlays;
        };
        unstable-pkgs = import nixpkgs-unstable {
          config.allowUnfree = true;
          inherit system;
          inherit overlays;
        };
        previous-pkgs = import nixpkgs-previous {
          config.allowUnfree = true;
          inherit system;
          inherit overlays;
        };

        master-pkgs = import nixpkgs-master {
          config.allowUnfree = true;
          inherit system;
          inherit overlays;
        };
        staging-pkgs = import nixpkgs-staging {
          config.allowUnfree = true;
          inherit system;
          inherit overlays;
        };
        pkgs = stable-pkgs // {
          # provides alias for all unstable pkgs SEE: https://rexk.github.io/en/blog/nix-home-manager-flake-setup/
          previous = previous-pkgs;
          unstable = unstable-pkgs;
          master = master-pkgs;
          staging = staging-pkgs;
          # neovim = unstable-pkgs.neovim;
          # neovim-unwrapped = unstable-pkgs.neovim-unwrapped;
        };
        le-just = pkgs.callPackage ./packages/just/default.nix { };
      in
      {
        apps = {
          home-manager = flake-utils.lib.mkApp { drv = pkgs.home-manager; };
          just = flake-utils.lib.mkApp { drv = le-just; };
          nixpkgs-fmt = flake-utils.lib.mkApp { drv = pkgs.nixpkgs-fmt; };
        };

        packages = {
          homeConfigurations = {
            "minimal" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ ./home-manager/minimal ];
              extraSpecialArgs = { inherit pkgs; };
            };

            "cli" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ ./home-manager/cli ];
              extraSpecialArgs = { inherit pkgs; };
            };
            "gui" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [ ./home-manager/gui ];
              extraSpecialArgs = { inherit pkgs; };
            };
          };
        };
      }
    );
}
