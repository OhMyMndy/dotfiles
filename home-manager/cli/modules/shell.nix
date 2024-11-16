{pkgs, ...}: {
  home.packages = with pkgs; [
    aria2
    atuin
    bat # TODO https://github.com/catppuccin/bat
    cpulimit
    curl
    gawk
    bat
    devenv # https://devenv.sh
    dialog
    eza # https://github.com/eza-community/eza
    hadolint
    ijq
    jless
    jq
    just
    lm_sensors
    p7zip
    restic
    shellcheck
    shfmt
    sqlite
    tree
    yq
    wget
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
