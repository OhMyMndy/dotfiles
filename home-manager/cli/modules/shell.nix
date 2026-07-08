{
  pkgs,
  lib,
  home,
  config,
  ...
}:
{
  imports = [ (import ./starship.nix) ];
  home.packages = with pkgs; [
    aria2
    atuin
    bat # TODO https://github.com/catppuccin/bat
    cpulimit
    curl
    dapr-cli
    devenv # https://devenv.sh
    direnv
    dialog
    eza # https://github.com/eza-community/eza
    fastgron # Make JSON greppable super fast!
    fd
    gawk
    gron
    ijq
    jless
    jq
    just
    lf
    lnav
    ncdu
    # openapi-generator-cli
    p7zip
    restic
    ripgrep
    shellcheck
    shfmt
    sqlite
    tmux # tmux 3.6a in Ubuntu has some weird quirks
    tree
    unstable.witr
    wget
    yq-go
    (yazi.override {
		_7zz = _7zz-rar;  # Support for RAR extraction
	  })
    semgrep # TODO: move to development.nix or something generic
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      lm_sensors
    osquery
  ];

  programs.fzf = {
    enable = false;
  };

  # programs.direnv = pkgs.lib.mkIf pkgs.stdenv.isLinux {
  #   enable = true;
  #   # nix-direnv.enable = true;
  # };

  # programs.nushell = {
  #   enable = true;
  # };

  # todo: create ssh keys automatically
  services.ssh-agent = {
    enable = true;
  };

  programs.mise = {
    enable = true;
    package = pkgs.unstable.mise;
  };


  home.file.".inputrc" = {
    source = ./../../../.inputrc;
  };
  home.file.".config/atuin/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink ./../../../.config/atuin/config.toml;
  };
  home.file."./.config/yazi/init.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink ./../../../.config/yazi/init.lua;
    recursive = false;
  };

  home.file."./.config/yazi/yazi.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink ./../../../.config/yazi/yazi.toml;
    recursive = false;
  };
  home.file."./.config/yazi/keymap.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink ./../../../.config/yazi/keymap.toml;
    recursive = false;
  };
  home.activation.setupYazi = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # TODO: install yazi git plugin: ya pkg add yazi-rs/plugins:git
    # todo: ya pkg add yazi-rs/plugins:vcs-files
  '';

}
