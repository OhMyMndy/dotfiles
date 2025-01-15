{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bitwarden-cli
    ecapture
    grype
    lynis
    # sysstat # lynis recommends this
    # aide # lynis recommends this
  ];
}
