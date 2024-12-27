{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs.master; [
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.impatience
    gnomeExtensions.search-light
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.tray-icons-reloaded
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
        "search-light@icedman.github.com"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      "dock-fixed" = true;
      "dash-max-icon-size" = 24;
      "hot-keys" = false;
      "apply-custom-theme" = true;
      "custom-theme-shrink" = true;
      "disable-overview-on-startup" = true;
      "show-mounts" = false;
      "show-trash" = false;
    };

    "org/gnome/shell/extensions/net/gfxmonk/impatience" = {
      "speed-factor" = 0.0;
    };

    # "org/gnome/shell/extensions/clipboard-indicator/history-size"
    "org/gnome/shell/extensions/clipboard-indicator" = {
      "history-size" = 200;
    };

    "org/gnome/shell/extensions/search-light" = {
      "popup-at-cursor-monitor" = true;
      "unit-converter" = true;
      "currency-converter" = true;
      # "text-color" = lib.hm.gvariant.mkTuple [
      #   1.0
      #   1.0
      #   1.0
      #   0.0
      # ];
      # "background-color" = lib.mkForce (
      #   lib.hm.gvariant.mkTuple [
      #     0.0
      #     0.0
      #     0.0
      #     1.0
      #   ]
      # );
    };
  };
}
