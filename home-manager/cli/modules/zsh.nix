{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (import ./starship.nix)
  ];

  home.packages = with pkgs; [
    git
    fzf
    direnv
  ];

  programs.zsh = {
    enable = true;
    package = pkgs.emptyDirectory;
    autosuggestion = {
      enable = true;
    };
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


    initExtra = ''
      ZSH_DISABLE_COMPFIX=true
      ${builtins.readFile "${./../../../.zshrc}"}
    '';

  };

  home.file.".zshrc.d" = {
    source = ./../../../.zshrc.d;
    recursive = true;
  };
}
