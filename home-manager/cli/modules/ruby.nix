{
  pkgs,
  lib,
  config,
  ...
}: {
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

  # programs.rbenv = {
  #   enable = false;
  #   plugins = [
  #     {
  #       name = "ruby-build";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "rbenv";
  #         repo = "ruby-build";
  #         rev = "v20240727";
  #         hash = "sha256-OjTVSmJbf6ngRLS66+wLT8WscVwfYBxpXUP9X/RLbXs=";
  #       };
  #     }
  #   ];
  # };

  # TODO: install dependencies
  # sudo dnf install -y ruby ruby-devel autoconf gcc rust patch make bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel perl
  home.activation.setupRuby = lib.hm.dag.entryAfter ["installPackages"] ''
    PATH="${config.home.path}/bin:$PATH"
    . ~/.asdf/asdf.sh
    ${pkgs.asdf-vm}/bin/asdf plugin add ruby
    RUBY_VERSION="$(${pkgs.asdf-vm}/bin/asdf list all ruby | grep -E '^3.3.[0-9]+$' | tail -1)"
    ${pkgs.asdf-vm}/bin/asdf install ruby $RUBY_VERSION
    ${pkgs.asdf-vm}/bin/asdf global ruby $RUBY_VERSION
  '';
}
