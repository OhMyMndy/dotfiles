{...}:
{
  dconf.settings = {
    "org/gnome/desktop/search-providers" = {
      disabled = [
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      # num-workspaces = "10";
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
  };
}
