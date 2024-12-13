{pkgs, ...}: {
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nix-search-cli
    treefmt
  ];
}
