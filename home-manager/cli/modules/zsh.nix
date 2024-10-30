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
    # initExtra = builtins.readFile ./../../../.zshrc;
    initExtra = ''
      ${builtins.readFile "${./../../../.zshrc}"}
      . "$HOME/.asdf/asdf.sh"
      . "$HOME/.asdf/completions/asdf.bash"
    '';
  };

  programs.starship = {
    enable = true;
    # SEE https://starship.rs/config/#default-prompt-format
    settings = {
      direnv.disabled = false;
      format = "\${custom.wsl_distro}$all";
      custom.wsl_distro = {
        command = "echo $WSL_DISTRO_NAME";
        when = ''test -n "$WSL_DISTRO_NAME"'';
        os = "linux";
        style = "bold white";
      };
    };
  };
}
