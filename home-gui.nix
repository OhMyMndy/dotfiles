{ pkgs, config, username, ... }: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ibm-plex

  ];

  home.file.".config/i3" = {
    source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/dotfiles/.config/i3";
    recursive = true;
  };

  # see https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=0
      '';
    };
  };


}
