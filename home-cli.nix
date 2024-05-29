# see: https://juliu.is/tidying-your-home-with-nix/
{ pkgs, username, ... }: {
  home.username = username; #(builtins.getEnv "USER");
  home.homeDirectory = "/home/${username}"; #./. + (builtins.getEnv "HOME");
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    distrobox
    k3s

    hadolint
    shellcheck
    shfmt


    tig

    ripgrep
    fd
    tree
    jq
    yq
    fzf

    delta

    thefuck


    nixpkgs-fmt

    go
    nodejs
    python3
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

  };
  home.file.".config/nvim" = {
    source = ./. + "/.config/nvim";
    recursive = true;
  };

  # todo .zshrc
  # todo .oh-my-zsh

  home.file.".bashrc" = {
    source = ./. + "/.bashrc";
  };

  home.file.".bash_profile" = {
    source = ./. + "/.bash_profile";
  };

  home.file.".bashrc.d" = {
    source = ./. + "/.bashrc.d";
    recursive = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile ./.tmux.conf;
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "terraform"
        "fzf"
        "gcloud"
        "thefuck"
        "direnv"
        "docker"
        "docker-compose"
        "kubectl"
      ];
      theme = "robbyrussell";

    };
    # initExtra = ''
    #   # see: https://stackoverflow.com/questions/18600188/home-end-keys-do-not-work-in-tmux
    #   bindkey  "^[OH"   beginning-of-line
    #   bindkey  "^[OF"   end-of-line

    #   bindkey  "^[[1~"   beginning-of-line
    #   bindkey  "^[[4~"   end-of-line
    # '';
    initExtra = builtins.readFile ./.zshrc;
  };

}
