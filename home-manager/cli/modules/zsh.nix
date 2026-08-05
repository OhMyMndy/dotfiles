{
  pkgs,
  lib,
  config,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    eza
    fzf
    git
  ];

  programs.zsh = {
    enable = true;
    # package = pkgs.emptyDirectory;
    autosuggestion = {
      enable = true;
    };
    envExtra = ''
      emulate sh -c 'source /etc/profile'
    '';
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
      ];
      patterns = {
        "rm -rf *" = "fg=red,bold";
      };
    };

    history = {
      append = true;
      expireDuplicatesFirst = true;
      share = true;
      ignoreSpace = true;
      ignorePatterns = [
        "rm *"
        "pkill *"
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo" # easily prefix your current or previous commands with sudo by pressing esc twice.
        "fzf"
        "direnv"
        "shell-proxy" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/shell-proxy
      ];
      theme = "fishy";
    };

    initContent = lib.mkMerge [
      # 900: after oh-my-zsh (800), before fzf's own integration (1000)
      (lib.mkOrder 900 ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      '')
      (lib.mkOrder 1400 ''
        #ZSH_DISABLE_COMPFIX=true
        ${builtins.readFile "${./../../../.zshrc}"}
      '')
      (lib.mkOrder 1500 ''
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''\${(s.:.)LS_COLORS}
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      # custom fzf flags
      # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
      zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
      # To make fzf-tab follow FZF_DEFAULT_OPTS.
      # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'
      '')
    ];
  };

  home.file.".zshrc.d" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.zshrc.d";
    recursive = true;
  };

  # TODO: add Nix zsh to shells and chsh
  # echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
}
