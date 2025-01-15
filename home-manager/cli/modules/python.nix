{
  pkgs,
  lib,
  config,
  ...
}:
{
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

  home.activation.setupUv = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:$PATH"
    . ~/.asdf/asdf.sh
    ${pkgs.asdf-vm}/bin/asdf plugin add uv
    ${pkgs.asdf-vm}/bin/asdf install uv latest
    ${pkgs.asdf-vm}/bin/asdf global uv latest

    ${pkgs.asdf-vm}/bin/asdf plugin add python

    PYTHON_VERSION="$(${pkgs.asdf-vm}/bin/asdf list all python | grep -E '^3.12.[0-9]+' | tail -1)"
    ${pkgs.asdf-vm}/bin/asdf install python $PYTHON_VERSION
    ${pkgs.asdf-vm}/bin/asdf global python $PYTHON_VERSION
  '';
}
