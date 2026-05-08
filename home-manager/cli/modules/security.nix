{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-cli
    ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    ecapture
    grype
    lynis
    # sysstat # lynis recommends this
    # aide # lynis recommends this
  ];
}
