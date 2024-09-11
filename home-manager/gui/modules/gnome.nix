{ lib, ... }:
let
  profileUUID = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
in
{
  imports = [
    (import ./gnome-extensions.nix)
  ];

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
    "org/gnome/desktop/search-providers" = {
      disabled = [
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = "10";
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/calendar" = {
      "show-weekdate" = true;
    };
    "org/gnome/desktop/interface" = {
      "enable-hot-corners" = false;
      "monospace-font-name" = "JetBrainsMonoNL Nerd Font Mono 10";
      "font-name" = "IBM Plex Sans 11";
      "document-font-name" = "IBM Plex Sans 11";
      "titlebar-font" = "IBM Plex Sans Bold 11";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/shell" = {
      "favorite-apps" = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "microsoft-edge.desktop"
        "org.gnome.Terminal.desktop"
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
        background-color = "rgb(0,0,0)";
        foreground-color = "rgb(255,255,255)";
        bold-is-bright = false;
        pallette = [
          "#ffffff"
          "#CD0000"
          "rgb(38,162,105)"
          "rgb(162,115,76)"
          "#00AAEE"
          "rgb(163,71,186)"
          "#00CDCD"
          "rgb(208,207,204)"
          "rgb(94,92,100)"
          "rgb(246,97,81)"
          "#FF0000"
          "rgb(233,173,12)"
          "#5CCAFF"
          "rgb(192,97,203)"
          "#00FFFF"
          "#ffffff"
        ];
      };

  };
}
