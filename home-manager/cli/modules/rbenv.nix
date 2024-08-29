{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autoconf
    patch
    stdenv.cc.cc.lib # For build-essential
    rustc
    openssl # For libssl-dev
    libyaml
    readline # For libreadline6-dev
    zlib
    gmp
    ncurses # For libncurses5-dev
    libffi
    gdbm # For libgdbm6
    db # For libdb
    libossp_uuid # For uuid
  ];

  programs.rbenv = {
    enable = true;
    plugins = [
      {
        name = "ruby-build";
        src = pkgs.fetchFromGitHub {
          owner = "rbenv";
          repo = "ruby-build";
          rev = "v20240727";
          hash = "sha256-OjTVSmJbf6ngRLS66+wLT8WscVwfYBxpXUP9X/RLbXs=";
        };
      }
    ];
  };

}
