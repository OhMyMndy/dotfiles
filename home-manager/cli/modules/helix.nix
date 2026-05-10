{
  pkgs,
  lib,
  home,
  ...
}:
{
  home.packages = with pkgs; [
    # helix # helix editor
  ];

  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      unstable.ansible-language-server
      basedpyright
      bash-language-server
      docker-language-server
      docker-compose-language-service
      gopls
      lua-language-server
      marksman
      nixd
      rust-analyzer
      terraform-ls
      yaml-language-server
    ];
  };

}
