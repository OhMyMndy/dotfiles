{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    (import ./asdf.nix)
  ];
  home.packages = with pkgs; [
    # autoconf
    # bzip2
    # bzip3
    # db # For libdb
    # gdbm # For libgdbm6
    # gmp
    # gnumake
    # libffi
    # libossp_uuid # For uuid
    # libyaml
    # ncurses # For libncurses5-dev
    # openssl # For libssl-dev
    # patch
    # readline # For libreadline6-dev
    # rustc
    # sqlite
    # stdenv.cc.cc.lib # For build-essential
    # zlib
    # zlib-ng
  ];

  programs.pyenv = {
    enable = false;
  };

  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        "python"
        "pylint"
      ];
    };
  };

  home.activation.setupUv = lib.hm.dag.entryAfter ["installPackages"] ''
    PATH="$PATH:${config.home.path}/bin:$HOME/.local/bin:$HOME/.asdf/shims"
    asdf plugin add uv >/dev/null
    asdf install uv latest >/dev/null
    asdf set -u uv latest

    asdf plugin add python

    PYTHON_VERSION="$(asdf list all python | grep -E '^3.12.[0-9]+' | tail -1)"
    asdf install python $PYTHON_VERSION >/dev/null
    asdf set -u python $PYTHON_VERSION
  '';
}
