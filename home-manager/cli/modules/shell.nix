{
  pkgs,
  lib,
  home,
  ...
}: {
  home.packages = with pkgs; [
    aria2
    atuin
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
    tree
    wget
    yq-go
    semgrep # TODO: move to development.nix or something generic
  ];

  programs.fzf = {
    enable = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nushell = {
    enable = true;
  };

  # todo: create ssh keys automatically
  services.ssh-agent = {
    enable = true;
  };

  home.file.".inputrc" = {
    source = ./../../../.inputrc;
  };
}
