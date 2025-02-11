{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux
    tmux-mem-cpu-load
  ];

  # SEE https://github.com/nix-community/home-manager/blob/master/modules/programs/tmux.nix
  programs.tmux = {
    enable = true;
    clock24 = true;
    customPaneNavigationAndResize = true;
    # keyMode = "vi";
    # terminal = "screen-256color";
    terminal = "tmux-256color";
    mouse = true;
    sensibleOnTop = true;
    baseIndex = 1;
    historyLimit = 10000;
    extraConfig = ''
      set -g pane-border-status top
      set -as terminal-features ",gnome*:RGB"
      set -as terminal-features ",tmux-256color:RGB"
      set -as terminal-features ",xterm-256color:RGB"

      set -g automatic-rename off
      set -s escape-time 0
      set -g repeat-time 0
      ${builtins.readFile ./../../../.tmux.conf}
    '';
  };
}
