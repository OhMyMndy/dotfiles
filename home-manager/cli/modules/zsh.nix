{ pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    git
    fzf
    direnv
    starship
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
      ];
      patterns = {
        "rm -rf *" = "fg=red,bold";
      };
    };
    history = {
      # TODO: available when upgrading to 24.11
      append = true;
      expireDuplicatesFirst = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo" # easily prefix your current or previous commands with sudo by pressing esc twice.
        "fzf"
        "direnv"
        "shell-proxy" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/shell-proxy
        "starship"
      ];
      # theme = "superjarin";
      theme = "fishy";
    };
    # initExtra = ''
    #   # see: https://stackoverflow.com/questions/18600188/home-end-keys-do-not-work-in-tmux
    #   bindkey  "^[OH"   beginning-of-line
    #   bindkey  "^[OF"   end-of-line

    #   bindkey  "^[[1~"   beginning-of-line
    #   bindkey  "^[[4~"   end-of-line
    # '';
    initExtra = builtins.readFile ./../../../.zshrc;
  };

  programs.starship = {
    enable = true;
    settings = {
      direnv.disabled = false;
    };
  };
}
