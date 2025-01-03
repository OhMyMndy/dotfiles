{
  pkgs,
  lib,
  home,
  ...
}:
{
  home.packages = with pkgs; [
    aria2
    atuin
    bat
    bat # TODO https://github.com/catppuccin/bat
    cpulimit
    curl
    dapr-cli
    devenv # https://devenv.sh
    dialog
    eza # https://github.com/eza-community/eza
    fastgron # Make JSON greppable super fast!
    gawk
    gron
    hadolint
    ijq
    jless
    jq
    just
    lm_sensors
    ncdu
    openapi-generator-cli
    osquery
    p7zip
    restic
    shellcheck
    shfmt
    sqlite
    texliveMedium
    tree
    wget
    yq-go
  ];

  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nushell = {
    enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };

  home.file.".inputrc" = {
    source = ./../../../.inputrc;
  };
}
