{ pkgs, ... }:
{
  home.packages = with pkgs; [
    atuin
    bat
    eza
    hadolint
    jq
    just
    shellcheck
    shfmt
    tree
    yq
  ];

  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };

  home.file.".inputrc" = {
    source = ./. + "/../../../.inputrc";
  };
}

