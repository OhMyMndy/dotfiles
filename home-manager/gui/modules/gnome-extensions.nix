{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.space-bar
  ];


  dconf.settings = {
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "sound-output-device-chooser@kgshank.net"
        "space-bar@luchrioh"
      ];
    };
  };
}
