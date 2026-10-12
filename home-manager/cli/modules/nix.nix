{ pkgs, config, dotfiles, ... }:
{
  home.packages = with pkgs; [
    nixfmt
    nix-search-cli
    treefmt
  ];
  home.file.".config/nixpkgs/config.nix".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nixpkgs/config.nix";
}
