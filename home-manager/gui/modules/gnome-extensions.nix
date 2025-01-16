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
    gnomeExtensions.just-perfection
    gnomeExtensions.impatience
    gnomeExtensions.open-bar
    gnomeExtensions.search-light
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.tiling-shell
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
        "tilingshell@ferrarodomenico.com"
        "gsconnect@andyholmes.github.io"
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
    "org/gnome/shell/extensions/tilingshell" = {
      "top-edge-maximize" = true;
      "inner-gaps" = lib.hm.gvariant.mkUint32 4;
      "outer-gaps" = lib.hm.gvariant.mkUint32 4;

      layouts-json = builtins.toJSON [
        {
          id = "1/1 H-Split";
          tiles = [
            {
              groups = [ 1 ];
              height = 1;
              width = 0.5;
              x = 0;
              y = 0;
            }
            {
              groups = [ 1 ];
              height = 1;
              width = 0.5;
              x = 0.5;
              y = 0;
            }
          ];
        }
        {
          id = "1/1 V-Split";
          tiles = [
            {
              groups = [ 1 ];
              height = 0.5;
              width = 1;
              x = 0;
              y = 0;
            }
            {
              groups = [ 1 ];
              height = 0.5;
              width = 1;
              x = 0;
              y = 0.5;
            }
          ];
        }
        {
          id = "1/2 H-Split";
          tiles = [
            {
              groups = [ 1 ];
              height = 1;
              width = 0.33;
              x = 0;
              y = 0;
            }
            {
              groups = [ 1 ];
              height = 1;
              width = 0.67;
              x = 0.33;
              y = 0;
            }
          ];
        }
        {
          id = "2/1 H-Split";
          tiles = [
            {
              groups = [ 1 ];
              height = 1;
              width = 0.67;
              x = 0;
              y = 0;
            }
            {
              groups = [ 1 ];
              height = 1;
              width = 0.33;
              x = 0.67;
              y = 0;
            }
          ];
        }
        {
          id = "1/1/1 H-Split";
          tiles = [
            {
              groups = [ 1 ];
              height = 1;
              width = 0.333333;
              x = 0;
              y = 0;
            }
            {
              groups = [ 1 ];
              height = 1;
              width = 0.333333;
              x = 0.333333;
              y = 0;
            }
            {
              groups = [ 1 ];
              height = 1;
              width = 0.333333;
              x = 0.666666;
              y = 0;
            }
          ];
        }
      ];
      #    /org/gnome/shell/extensions/tilingshell/overridden-settings
      #  "{\"org.gnome.mutter.keybindings\":{\"toggle-tiled-right\":\"['<Super>Right']\",\"toggle-tiled-left\":\"['<Super>Left']\"},\"org.gnome.desktop.wm.keybindings\":{\"maximize\":\"['<Super>Up']\",\"unmaximize\":\"['<Super>Down', '<Alt>F5']\"},\"org.gnome.mutter\":{\"edge-tiling\":\"true\"}}"
    };
  };
}
