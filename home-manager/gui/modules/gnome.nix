{ pkgs, lib, ... }:
let
  profileUUID = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
in
{
  imports = [ (import ./gnome-extensions.nix) ];
  home.packages = with pkgs; [
    # (pkgs.nerd-fonts.override {
    #   fonts = [
    #     "Iosevka"
    #     "IosevkaTerm"
    #     "IosevkaTermSlab"
    #     "JetBrainsMono"
    #     "Meslo"
    #     "Ubuntu"
    #     "UbuntuMono"
    #     "UbuntuSans"
    #   ];
    # })
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    ibm-plex
    inter
  ];
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
  #  gsettings set org.gnome.mutter experimental-features "["scale-monitor-framebuffer"]"
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
      "switch-to-workspace-left" = [ "<Super>Page_Up" ];
      "switch-to-workspace-right" = [ "<Super>Page_Down" ];
      "move-to-workspace-1" = [ "<Super><Shift>1" ];
      "move-to-workspace-2" = [ "<Super><Shift>2" ];
      "move-to-workspace-3" = [ "<Super><Shift>3" ];
      "move-to-workspace-4" = [ "<Super><Shift>4" ];
      "move-to-workspace-5" = [ "<Super><Shift>5" ];
      "move-to-workspace-6" = [ "<Super><Shift>6" ];
      "move-to-workspace-7" = [ "<Super><Shift>7" ];
      "move-to-workspace-8" = [ "<Super><Shift>8" ];
      "move-to-workspace-9" = [ "<Super><Shift>9" ];
      "move-to-workspace-10" = [ "<Super><Shift>0" ];
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
      num-workspaces = 6;
      # button-layout = "close,minimize,maximize:appmenu";
      button-layout = "appmenu:minimize,maximize,close";
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
      "monospace-font-name" = "Iosevka Nerd Font Mono 11"; # "JetBrainsMonoNL Nerd Font Mono 10";
      "font-name" = "Ubuntu Sans 11";
      "document-font-name" = "Ubuntu Sans 11";
      "titlebar-font" = "Ubuntu Sans Bold 11";
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
      "sleep-inactive-ac-timeout" = 600;
      "sleep-inactive-ac-type" = "suspend";
    };
    "org/gnome/shell"."favorite-apps" = [
      "org.gnome.Nautilus.desktop"
      "org.mozilla.firefox.desktop"
      "proton-mail.desktop"
      "com.automattic.beeper.desktop"
      "org.gnome.Terminal.desktop"
      "jetbrains-idea-a0ba9843-b237-4000-9db0-5d85a0d89b2a.desktop"
      "dev.aunetx.deezer.desktop"
      "com.protonvpn.www.desktop"
      "org.prismlauncher.PrismLauncher.desktop"
      "net.agalwood.Motrix.desktop"
    ];

    "org/gnome/shell/keybindings" = {
      "switch-to-application-1" = [ ];
      "switch-to-application-2" = [ ];
      "switch-to-application-3" = [ ];
      "switch-to-application-4" = [ ];
      "switch-to-application-5" = [ ];
      "switch-to-application-6" = [ ];
      "switch-to-application-7" = [ ];
      "switch-to-application-8" = [ ];
      "switch-to-application-9" = [ ];
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

  # TODO: add hook to run fc-cache -f
}
