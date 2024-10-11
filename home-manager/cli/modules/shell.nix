{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aria2
    atuin
    bat
    devenv # https://devenv.sh
    dialog
    eza # https://github.com/eza-community/eza
    hadolint
    jless
    jq
    just
    lm_sensors
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
    source = ./../../../.inputrc;
  };
}
