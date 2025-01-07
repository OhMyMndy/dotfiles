{ pkgs, ... }:
{
  home.packages = with pkgs; [ tmux ];

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
    plugins = with pkgs.master; [
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      # Since the version in nixpkgs is old, lets use it directly from GitHub
      {
        plugin = tmuxPlugins.mkTmuxPlugin {
          pluginName = "catppuccin";
          version = "v2.1.0";
          src = fetchFromGitHub {
            owner = "catppuccin";
            repo = "tmux";
            rev = "d6458527ef121cc280c5dd119ba638749de1f713";
            hash = "sha256-kWixGC3CJiFj+YXqHRMbeShC/Tl+1phhupYAIo9bivE=";
          };
        };
        extraConfig = ''
          set -ogq @catppuccin_pane_status_enabled "yes" # set to "yes" to enable
          set -ogq @catppuccin_window_text " #{window_name}"
          set -ogq @catppuccin_window_current_text " #{window_name}"
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          # set -g @resurrect-processes '"~nvim"'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      tmuxPlugins.prefix-highlight
      {
        plugin = tmuxPlugins.better-mouse-mode;
        extraConfig = ''
          set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
        '';
      }
      tmuxPlugins.yank
      tmuxPlugins.pain-control
    ];
    extraConfig = ''
      set -g pane-border-status top
      set -as terminal-features ",gnome*:RGB"
      set -as terminal-features ",tmux-256color:RGB"
      set -as terminal-features ",xterm-256color:RGB"

      set -g automatic-rename off
      set -s escape-time 0
      set -g repeat-time 0
    '';
  };
}
