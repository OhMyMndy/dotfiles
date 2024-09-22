{ pkgs, ... }:
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
}
