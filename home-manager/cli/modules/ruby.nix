{ pkgs, lib, config, ... }:
{
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
  # sudo dnf install -y autoconf gcc rust patch make bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel perl
  # home.activation.setupRuby = lib.hm.dag.entryAfter [ "installPackages" ] ''
  #   PATH="${config.home.path}/bin:$PATH"
  #   # . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
  #   ${pkgs.asdf-vm}/bin/asdf plugin add ruby
  #   ${pkgs.asdf-vm}/bin/asdf install ruby
  #   ${pkgs.asdf-vm}/bin/asdf install ruby latest
  #   ${pkgs.asdf-vm}/bin/asdf global ruby latest
  # '';
}
