{ pkgs, lib, config, ... }:
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
        "uv"
      ];
    };
  };
  
  home.activation.setupUv = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    # . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
    ${pkgs.asdf-vm}/bin/asdf plugin add uv
    ${pkgs.asdf-vm}/bin/asdf install uv
    ${pkgs.asdf-vm}/bin/asdf install uv latest
    ${pkgs.asdf-vm}/bin/asdf global uv latest
  '';
}
