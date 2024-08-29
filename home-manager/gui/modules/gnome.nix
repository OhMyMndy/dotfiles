{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
  };
}
