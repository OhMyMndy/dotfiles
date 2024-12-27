{
  pkgs,
  lib,
  ...
}:
let
  treesitterWithGrammars = (
    pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.bash
      p.bibtex
      p.c
      p.c_sharp
      p.cmake
      p.comment
      p.css
      p.dart
      p.desktop
      p.dockerfile
      p.earthfile
      p.editorconfig
      p.fish
      p.git_config
      p.gitattributes
      p.gitcommit
      p.gitignore
      p.go
      p.gomod
      p.gosum
      p.gotmpl
      p.gowork
      p.hcl
      p.helm
      p.html
      p.java
      p.javascript
      p.jq
      p.json
      p.json5
      p.just
      p.latex
      p.lua
      p.luadoc
      p.make
      p.markdown
      p.mermaid
      p.nginx
      p.nix
      p.php
      p.python
      p.rego
      p.rst
      p.ruby
      p.rust
      p.sql
      p.ssh_config
      p.terraform
      p.tmux
      p.toml
      p.toml
      p.tsx
      p.typescript
      p.udev
      p.vala
      p.vim
      p.vimdoc
      p.vue
      p.xml
      p.yaml
    ])
  );

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };
in
{
  # TODO:check which language servers are installed through Mason and friends
  home.packages = with pkgs; [
    fd
    fzf
    ripgrep
    # TODO:does not contain annobin which is needed for installing http_parser dependency for Jekyll
    # gcc
    # go
    # cargo
    gnumake
    # vala

    # shellcheck
    # hadolint

    # ansible-language-server
    # ansible-lint
    alejandra
    clang-tools_18 # clangd
    # dart
    deadnix
    docker-ls
    gopls
    helm-ls
    htmx-lsp
    # lua-language-server
    nil # nix language server
    nixd
    # nodePackages_latest.bash-language-server
    # nodePackages_latest.typescript-language-server
    # nodePackages_latest.vscode-html-languageserver-bin
    # nodePackages_latest.vscode-json-languageserver
    # pyright
    # rubyPackages_3_3.ruby-lsp
    # ruff-lsp # python lsp
    rust-analyzer
    statix
    # stylua
    # taplo # TOML LSP
    # terraform-ls
    # tflint
    # tfsec
    # vala-language-server
    # yaml-language-server
    tree-sitter
    yamlfmt
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    plugins = [ treesitterWithGrammars ];
    defaultEditor = true;
    extraLuaConfig = ''
      vim.opt.runtimepath:prepend("${treesitter-parsers}")
      ${builtins.readFile ./../../../.config/nvim/init.lua}
    '';
  };

  # Treesitter is configured as a locally developed module in lazy.nvim
  # we hardcode a symlink here so that we can refer to it in our lazy config
  # SEE: https://github.com/Kidsan/nixos-config/blob/main/home/programs/neovim/default.nix
  home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
    recursive = true;
    source = treesitterWithGrammars;
  };

  # TODO: keyboard shortcut to hide popup messages
  home.file."./.config/nvim/lua" = {
    source = ./../../../.config/nvim/lua;
    recursive = true;
  };

  # TODO update lazy-lock: https://github.com/vdbe/nvim/blob/2c12d00beaa8e4c2f2bc98350a309472321e63f6/nix/apps.nix#L22
  # home.file."./.config/nvim/lazy-lock.json" = {
  #   source = config.lib.file.mkOutOfStoreSymlink ./../../../.config/nvim/lazy-lock.json;
  # };

  home.activation.setupNeovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cp -f ${./../../../.config/nvim/lazy-lock.json} ~/.config/nvim/lazy-lock.json
    chmod 0644 ~/.config/nvim/lazy-lock.json
  '';
}
