{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.appindicator
    gnomeExtensions.impatience
  ];


  dconf.settings = {
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "sound-output-device-chooser@kgshank.net"
        "trayIconsReloaded@selfmade.pl"
        "impatience@gfxmonk.net"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      "dock-fixed" = true;
      "dash-max-icon-size" = 24;
      "hot-keys" = false;
      "apply-custom-theme" = true;
      "custom-theme-shrink" = true;
      "disable-overview-on-startup" = true;
    };

    "org/gnome/shell/extensions/net/gfxmonk/impatience" = {
      "speed-factor" = 0.0;
    };
  };
}
