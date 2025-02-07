{pkgs, ...}: let
in
  # prefs = import ../../mixins/preferences.nix;
  # colors = prefs.color;
  {
    programs.alacritty = {
      enable = true;
      package = pkgs.emptyDirectory;
      settings = {
        env = {
          TERM = "tmux-256color";
        };
        terminal = {
          shell = "/bin/zsh";
        };
        font = {
          normal.family = "JetBrainsMonoNL Nerd Font Mono";
          # normal.family = "IntelOne Mono";
          # normal.family = "Comic Mono";
          # size = font.size;
        };
        #cursor.style = {
        #  shape = "Block";
        #  blinking = "Always";
        #};
        #cursor.blink_interval = 250;
        window = {
          opacity = 1.0;
          padding = {
            x = 5;
            y = 5;
          };
        };
        hints.enabled = [
          {
            # hyperlinks = false;
            command = "true";
            regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>\"\\\\s{-}\\\\^⟨⟩`]+";
            mouse.enabled = false;
          }
        ];
        colors = {
          # draw_bold_text_with_bright_colors = colors.bold_as_bright;
          primary.foreground = "#ffffff"; # colors.foreground;
          primary.background = "#000000"; # colors.background;

          # normal = {
          #   inherit (colors) black;
          #   inherit (colors) red;
          #   inherit (colors) green;
          #   inherit (colors) yellow;
          #   inherit (colors) blue;
          #   magenta = colors.purple;
          #   inherit (colors) cyan;
          #   inherit (colors) white;
          # };
          # bright = {
          #   black = colors.brightBlack;
          #   red = colors.brightRed;
          #   green = colors.brightGreen;
          #   yellow = colors.brightYellow;
          #   blue = colors.brightBlue;
          #   magenta = colors.brightPurple;
          #   cyan = colors.brightCyan;
          #   white = colors.brightWhite;
          # };
        };
      };
    };
  }
