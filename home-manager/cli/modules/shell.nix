{
  pkgs,
  lib,
  home,
  config,
  dotfiles,
  ...
}:
{
  imports = [ (import ./starship.nix) ];
  home.packages =
    with pkgs;
    [
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
      pv
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
        _7zz = _7zz-rar; # Support for RAR extraction
      })
      semgrep # TODO: move to development.nix or something generic
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
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

  home.file.".inputrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.inputrc";
  home.file.".config/atuin/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/atuin/config.toml";
  home.file.".config/yazi/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/yazi/init.lua";
  home.file.".config/yazi/yazi.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/yazi/yazi.toml";
  home.file.".config/yazi/keymap.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/yazi/keymap.toml";
  home.activation.setupYazi = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # TODO: install yazi git plugin: ya pkg add yazi-rs/plugins:git
    # todo: ya pkg add yazi-rs/plugins:vcs-files
  '';

  home.activation.setupSafeChain = lib.hm.dag.entryAfter [ "installPackages" ] ''
    if [[ ! -d ~/.safe-chain ]]; then
      ${pkgs.curl}/bin/burl -fsSL https://github.com/AikidoSec/safe-chain/releases/download/1.5.14/install-safe-chain.sh -o /tmp/install-safe-chain.sh \
        && echo "d41816ab564e9b9238946786433eec15e2d0e699698fa81c1fd1bdd3a78adf5c  /tmp/install-safe-chain.sh" | sha256sum -c - \
        && sh /tmp/install-safe-chain.sh \
        && rm /tmp/install-safe-chain.sh
    fi
  '';

}
