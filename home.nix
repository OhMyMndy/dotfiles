# see: https://juliu.is/tidying-your-home-with-nix/

{ pkgs, ... }: {
  home.username = "vscode";
  home.homeDirectory = "/home/vscode";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # sudo $(which podman) image trust set -t reject default
    # sudo $(which podman) image trust set --type accept docker.io
    podman
    distrobox
    k3s

    hadolint
    shellcheck


    tig

    ripgrep
    tree
    jq
    yq

    delta

    nixpkgs-fmt
  ];


  programs.git = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.nvim-treesitter
      vimPlugins.nvim-treesitter-context
      vimPlugins.vim-nix
      vimPlugins.nvim-lastplace
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-cmp
      vimPlugins.cmp-path
      vimPlugins.vim-commentary
      vimPlugins.lsp-zero-nvim
      vimPlugins.cmp-nvim-lsp
    ];

    extraLuaConfig = builtins.readFile ./nvim/config.lua;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile ./tmux/.tmux.conf;
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
    initExtra = builtins.readFile ./zsh/.zshrc;

  };
}
