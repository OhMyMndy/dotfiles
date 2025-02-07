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
    plugins = with pkgs.master; [
      tmuxPlugins.cpu
      # Since the version in nixpkgs is old, lets use it directly from GitHub
      # {
      #   plugin = tmuxPlugins.mkTmuxPlugin {
      #     pluginName = "catppuccin";
      #     version = "v2.1.0";
      #     src = fetchFromGitHub {
      #       owner = "catppuccin";
      #       repo = "tmux";
      #       rev = "d6458527ef121cc280c5dd119ba638749de1f713";
      #       hash = "sha256-kWixGC3CJiFj+YXqHRMbeShC/Tl+1phhupYAIo9bivE=";
      #     };
      #   };
      #   # plugin = tmuxPlugins.catppuccin;
      #   extraConfig = ''
      #     # set -g @catppuccin_flavor "mocha"
      #     set -g @catppuccin_window_status_style "basic"
      #     set -g status-right "#{E:@catppuccin_status_load}#{E:@catppuccin_status_session}#{E:@catppuccin_status_date_time}"
      #     set -ag status-right "#[fg=#{@thm_fg},bg=#{@thm_mantle}] #(tmux-mem-cpu-load  -i 10 -g 0 -a 0 -m 0 -t 0) "
      #     # set -ogq @catppuccin_pane_status_enabled "yes" # set to "yes" to enable
      #     set -ogq @catppuccin_window_text " #{window_name}"
      #     set -ogq @catppuccin_window_current_text " #{window_name}"
      #     # # run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      #     # # set -g status-right ""
      #     set -g status-right-length 100
      #     # # set -g status-right "#{E:@catppuccin_status_application}"
      #     # set -g status-right "#{prefix_highlight}"
      #     # set -agF status-right "#{E:@catppuccin_status_cpu}"
      #     # set -ag status-right "#{E:@catppuccin_status_session}"
      #     # set -ag status-right "#{E:@catppuccin_status_uptime}"
      #     # run ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      #   '';
      # }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          # set -g @resurrect-strategy-vim 'session'
          # set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          # set -g @resurrect-processes ':all:'
          set -g @resurrect-processes 'ssh lazygit less tail watch ssh "~nvim->nvim"'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '3'
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
