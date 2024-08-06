# see: https://juliu.is/tidying-your-home-with-nix/
{ pkgs, config, username, lib, ... }: 

let newTerraform = pkgs.terraform.overrideAttrs (old: {
  #plugins = [];
});

treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.html
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.ruby
    p.rust
    p.sql
    p.toml
    p.typescript
    p.terraform
    p.vim
    p.vue
    p.xml
    p.yaml
  ]));

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };

in {
  home.username = username; #(builtins.getEnv "USER");
  home.homeDirectory = "/home/${username}"; #./. + (builtins.getEnv "HOME");
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [

    tmux
    zellij

    distrobox
    k3s

    hadolint
    shellcheck
    shfmt

    git
    tig
    gh
    gitkraken

    ripgrep
    fd
    tree
    jq
    yq
    fzf
    eza
    just

    delta

    thefuck


    nixpkgs-fmt

    go

    cargo

    nodejs

    python3
    newTerraform

    nodePackages_latest.bash-language-server
    ruff-lsp # python lsp
    pyright
    clang-tools_18 # clangd
    yaml-language-server
    nil # nix language server
    terraform-ls
    tflint
    htmx-lsp
    gopls
    docker-ls
    lua-language-server
    stylua
    nodePackages_latest.typescript-language-server
    ansible-language-server
    nodePackages_latest.vscode-html-languageserver-bin
    nodePackages_latest.vscode-json-languageserver
    
    rubyPackages_3_3.ruby-lsp
    rust-analyzer
    taplo # TOML LSP
    dart

#    php82
#    php82Extensions.curl 
#    php82Extensions.imagick 
#    php82Extensions.opcache 
#    php82Extensions.redis 
#    php82Extensions.pdo_mysql 
#    php82Extensions.pdo 
#    php82Extensions.mysqlnd
#    php82Extensions.openssl 
#    php82Extensions.posix 
#    php82Extensions.sodium 
#    php82Extensions.sockets 
#    php82Extensions.zip 
#    php82Extensions.yaml 
#    php82Extensions.xdebug
#    php82Packages.composer
      
    

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
    package = pkgs.neovim-unwrapped;
    plugins = [
      treesitterWithGrammars
    ];

  };


#  home.file.".config/nvim/lazy-lock.json" = {
#    source = config.lib.file.mkOutOfStoreSymlink ./.config/nvim/lazy-lock.json;
#  };
    
  home.activation.setupGit = lib.hm.dag.entryAfter [ "installPackages" ] ''
    ${pkgs.git}/bin/git config --global include.path ".gitconfig-delta"
  '';
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/dotfiles/.config/nvim";
    recursive = true;
  };

  home.file.".config/fish" = {
    source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/dotfiles/.config/fish";
    recursive = true;
  };

  home.file.".gitconfig-delta" = {
    source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/dotfiles/.gitconfig-delta";
  };
  # Treesitter is configured as a locally developed module in lazy.nvim
  # we hardcode a symlink here so that we can refer to it in our lazy config
  # SEE: https://github.com/Kidsan/nixos-config/blob/main/home/programs/neovim/default.nix
  home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
    recursive = true;
    source = treesitterWithGrammars;
  };

  home.file."./.config/nvim/lua/treesitter_config.lua".text = ''
    vim.opt.runtimepath:prepend("${treesitter-parsers}")
  '';

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
