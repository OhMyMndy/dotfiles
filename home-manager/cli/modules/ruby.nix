{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    (import ./asdf.nix)
  ];
  home.packages = with pkgs; [
    # autoconf
    # patch
    # stdenv.cc.cc.lib # For build-essential
    # rustc
    # openssl # For libssl-dev
    # libyaml
    # readline # For libreadline6-dev
    # zlib
    # gmp
    # ncurses # For libncurses5-dev
    # libffi
    # gdbm # For libgdbm6
    # db # For libdb
    # libossp_uuid # For uuid
  ];

  # TODO: install dependencies
  # sudo dnf install -y ruby ruby-devel autoconf gcc rust patch make bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel perl
  home.activation.setupRuby = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="$PATH:${config.home.path}/bin:$HOME/.local/bin:$HOME/.asdf/shims"

    # TODO: check if dependencies are installed before attempting to install
    # asdf plugin add ruby
    # RUBY_VERSION="$(asdf list all ruby | grep -E '^3.3.[0-9]+$' | tail -1)"
    # asdf install ruby $RUBY_VERSION
    # asdf set -u ruby $RUBY_VERSION
  '';
}
