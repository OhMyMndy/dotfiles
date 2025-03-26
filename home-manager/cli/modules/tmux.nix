{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux
  ];

  # SEE https://github.com/nix-community/home-manager/blob/master/modules/programs/tmux.nix
  programs.tmux = {
    enable = true;
    clock24 = true;
    customPaneNavigationAndResize = true;
    terminal = "tmux-256color";
    mouse = true;
    sensibleOnTop = true;
    baseIndex = 1;
    historyLimit = 10000;
    plugins = with pkgs.master; [
      {
        # plugin = tmuxPlugins.resurrect;
        plugin = tmuxPlugins.mkTmuxPlugin {
          pluginName = "resurrect";
          version = "v4.0.0";
          src = fetchFromGitHub {
            owner = "tmux-plugins";
            repo = "tmux-resurrect";
            rev = "e87d7d592cac97fa38c12395ebec042c154a1844";
            hash = "sha256-44Ok7TbNfssMoBmOAqLLOj7oYRG3AQWrCuLzP8tA8Kg=";
          };
          postInstall = ''
            rm -rf $target/run_tests
            rm -rf $target/tests
            rm -rf $target/lib/tmux-test
          '';

        };
        extraConfig = ''
          # set -g @resurrect-strategy-vim 'session'
          # set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          # set -g @resurrect-processes ':all:'
          set -g @resurrect-processes 'ssh lazygit less tail watch ssh'
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
      set -as terminal-features ",gnome*:RGB"
      set -as terminal-features ",tmux-256color:RGB"
      set -as terminal-features ",xterm-256color:RGB"

      set -s escape-time 0
      set -g repeat-time 0
      ${builtins.readFile ./../../../.tmux.conf}
    '';
  };
}
