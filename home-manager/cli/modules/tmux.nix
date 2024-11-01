{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux
  ];
  programs.tmux = {
    enable = true;
    clock24 = true;
    customPaneNavigationAndResize = true;
    # keyMode = "vi";
    # terminal = "tmux-256color";
    mouse = true;
    sensibleOnTop = true;
    plugins = with pkgs; [
      tmuxPlugins.continuum
      # {
      #   plugin = tmuxPlugins.dracula;
      #   extraConfig = ''
      #     set -g @dracula-battery-label false
      #     set -g @dracula-no-battery-label true
      #     set -g @dracula-show-battery-status false
      #
      #     # available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, tmux-ram-usage, network, network-bandwidth, network-ping, ssh-session, attached-clients, network-vpn, weather, time, mpc, spotify-tui, krbtgt, playerctl, kubernetes-context, synchronize-panes
      #     set -g @dracula-plugins "cpu-usage gpu-usage ram-usage synchronize-panes"
      #   '';
      # }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -ogq @catppuccin_pane_status_enabled "yes" # set to "yes" to enable
          # set -ogq @catppuccin_pane_active_border_style "##{?pane_in_mode,fg=#{@thm_lavender},##{?pane_synchronized,fg=#{@thm_mauve},fg=#{@thm_lavender}}}"
        #   set -ogq @catppuccin_pane_border_status "yes" # set to "yes" to enable
        '';
      }
      tmuxPlugins.resurrect
      tmuxPlugins.prefix-highlight
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
      tmuxPlugins.pain-control
    ];
    # extraConfig = builtins.readFile ./../../../.tmux.conf;
    extraConfig = ''
      set -g pane-border-status top
      set -as terminal-features ",gnome*:RGB"
    '';
  };

}
