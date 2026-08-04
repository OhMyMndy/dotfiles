{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # _1password-cli
      bitwarden-cli
      rbw
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      ecapture
      grype
      lynis
      # sysstat # lynis recommends this
      # aide # lynis recommends this
    ];
}
