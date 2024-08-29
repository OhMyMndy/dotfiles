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
  home.homeDirectory = (builtins.getEnv "HOME");
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  # xdg.enable = true;
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
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
    lazygit
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
    atuin

    delta

    nmap
    thefuck

    libsecret

    nixpkgs-fmt

    go
    gcc
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


    talosctl
    bat
    traceroute
    iputils
    bind # for dig
    btop
    htop

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

  services.ssh-agent = {
    enable = true;
  };
  home.file.".config/lazygit" = {
    source = config.lib.file.mkOutOfStoreSymlink ./.config/lazygit;
  };
    
  home.activation.setupGit = lib.hm.dag.entryAfter [ "installPackages" ] ''
    (cd "$HOME"
    touch ".gitconfig"
    ${pkgs.git}/bin/git config --global include.path ".gitconfig-delta")
    mkdir -p .config/nvim/lua
    echo "vim.opt.runtimepath:prepend(\"${treesitter-parsers}\")" > ~/.config/nvim/lua/treesitter_config.lua
    if [ ! -f ~/.config/nvim/lua/treesitter_config.lua ]; then
      ln -s .config/nvim/lua/treesitter_config.lua ~/.config/nvim/lua/treesitter_config.lua
    fi
  '';


  home.file."./.config/fish/fish_variables" = {
    source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/dotfiles/.config/fish_variables";
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

  home.file."./.config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/dotfiles/.config/nvim";
    recursive = true;
  };
  home.file."./.config/zellij" = {
    source = config.lib.file.mkOutOfStoreSymlink  "${config.home.homeDirectory}/dotfiles/.config/zellij";
    recursive = true;
  };
  # home.file.".bashrc" = {
    # source = ./. + "/.bashrc";
  # };

  # home.file.".bash_profile" = {
    # source = ./. + "/.bash_profile";
  # };

  home.file.".bashrc.d" = {
    source = ./. + "/.bashrc.d";
    recursive = true;
  };

  home.file.".inputrc" = {
    source = ./. + "/.inputrc";
  };

  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./.bashrc;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # disable fish greeting
      set fish_greeting
      fish_config theme choose tokyonight
      fish_add_path -p ~/.nix-profile/bin /nix/var/nix/profiles/default/bin

      set fish_cursor_default     block      blink
      set fish_cursor_insert      line       blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_visual      block

      set -g fish_key_bindings fish_vi_key_bindings
      bind -M insert \cc kill-whole-line repaint
    '';
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
