{ lib, ... }:
let
  profileUUID = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
in
{
  imports = [ (import ./gnome-extensions.nix) ];
  # TODO fix xdg-open with flatpak applications
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-gnome
  #   ];
  #   xdgOpenUsePortal = true;
  # };
  # Set fractional scaling for Wayland:
  #  gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      "switch-input-source" = [ ];
      "switch-input-source-backward" = [ ];
      "switch-to-workspace-1" = [ "<Super>1" ];
      "switch-to-workspace-2" = [ "<Super>2" ];
      "switch-to-workspace-3" = [ "<Super>3" ];
      "switch-to-workspace-4" = [ "<Super>4" ];
      "switch-to-workspace-5" = [ "<Super>5" ];
      "switch-to-workspace-6" = [ "<Super>6" ];
      "switch-to-workspace-7" = [ "<Super>7" ];
      "switch-to-workspace-8" = [ "<Super>8" ];
      "switch-to-workspace-9" = [ "<Super>9" ];
      "switch-to-workspace-10" = [ "<Super>10" ];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      "natural-scroll" = false;
      "two-finger-scrolling-enabled" = true;
      "disable-while-typing" = true;
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [
        "org.gnome.Nautilus.desktop"
        "org.mozilla.firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Contacts.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.Characters.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.Boxes.desktop"
      ];
    };
    "org/gnome/desktop/session" = {
      "idle-delay" = lib.hm.gvariant.mkUint32 300;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = "10";
      button-layout = "close,minimize,maximize:appmenu";
      resize-with-right-button = true;
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/calendar" = {
      "show-weekdate" = true;
    };
    "org/gnome/desktop/interface" = {
      "enable-animations" = false;
      "accent-color" = "pink";
      "enable-hot-corners" = true;
      "monospace-font-name" = "JetBrainsMonoNL Nerd Font Mono 10";
      "font-name" = "IBM Plex Sans 11";
      "document-font-name" = "IBM Plex Sans 11";
      "titlebar-font" = "IBM Plex Sans Bold 11";
      "clock-format" = "24h";
    };
    "org/gnome/desktop/wm/preferences" = {
      "mouse-button-modifier" = "<Alt>";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/color" = {
      "night-light-enabled" = true;
      "night-light-schedule-automatic" = true;
      "night-light-schedule-from" = 5.0;
      "night-light-schedule-to" = 4.0;
      "night-light-temperature" = lib.hm.gvariant.mkUint32 4300;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      "sleep-inactive-ac-timeout" = 660; # 6 minutes
    };
    "org/gnome/shell" = {
      "favorite-apps" = [
        "org.gnome.Nautilus.desktop"
        "org.mozilla.firefox.desktop"
        "microsoft-edge.desktop"
        "org.gnome.Geary.desktop"
        "org.signal.Signal.desktop"
        "com.vixalien.sticky.desktop"
        "md.obsidian.Obsidian.desktop"
        # "org.gnome.Terminal.desktop"
        "Alacritty.desktop"
      ];
    };
    "org/gnome/terminal/legacy/profiles:" = {
      default = profileUUID;
      list = [ profileUUID ];
    };
    "org/gnome/terminal/legacy/profiles:/:${profileUUID}" = {
      visible-name = "OhMyMndy Dark";
      audible-bell = true;
      use-system-font = true;
      use-theme-colors = false;
      # catppuccin-mocha
      # https://github.com/catppuccin/gnome-terminal
      # curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.3.0/install.py | python3 -
      background-color = "#1e1e2e";
      foreground-color = "#F2F5FE";
      bold-is-bright = false;
      palette = [
        "#45475a"
        "#f38ba8"
        "#a6e3a1"
        "#f9e2af"
        "#89b4fa"
        "#f5c2e7"
        "#94e2d5"
        "#F2F5FE"
        "#585b70"
        "#f38ba8"
        "#a6e3a1"
        "#f9e2af"
        "#89b4fa"
        "#f5c2e7"
        "#94e2d5"
        "#F2F5FE"

        # "#bcc0cc"
        # "#d20f39"
        # "#40a02b"
        # "#df8e1d"
        # # todo
        # "#00AAEE"
        # "rgb(163,71,186)"
        # "#00CDCD"
        # "rgb(208,207,204)"
        # "rgb(94,92,100)"
        # "rgb(246,97,81)"
        # "#FF0000"
        # "rgb(233,173,12)"
        # "#5CCAFF"
        # "rgb(192,97,203)"
        # "#00FFFF"
        # "#ffffff"
      ];
    };
    "org/gtk/settings/file-chooser" = {
      "clock-format" = "24h";
    };

    # TODO: add nightlight config
  };
}
