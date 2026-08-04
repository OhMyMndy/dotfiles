{
  pkgs,
  lib,
  config,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
    git
    fzf
  ];

  programs.zsh = {
    enable = true;
    package = pkgs.emptyDirectory;
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

    initContent = ''
      ZSH_DISABLE_COMPFIX=true
      ${builtins.readFile "${./../../../.zshrc}"}
    '';

  };

  home.file.".zshrc.d" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.zshrc.d";
    recursive = true;
  };
}
