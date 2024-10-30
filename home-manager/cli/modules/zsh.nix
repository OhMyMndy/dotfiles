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
      # SEE https://github.com/catppuccin/zsh-syntax-highlighting/blob/main/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh
      styles = {
        comment = "fg=#5b6078";
        alias = "fg=#a6da95";
        suffix-alias = "fg=#a6da95";
        global-alias = "fg=#a6da95";
        function = "fg=#a6da95";
        command = "fg=#a6da95";
        precommand = "fg=#a6da95,italic";
        autodirectory = "fg=#f5a97f,italic";
        single-hyphen-option = "fg=#f5a97f";
        double-hyphen-option = "fg=#f5a97f";
        back-quoted-argument = "fg=#c6a0f6";
        builtin = "fg=#a6da95";
        reserved-word = "fg=#a6da95";
        hashed-command = "fg=#a6da95";
        commandseparator = "fg=#ed8796";
        command-substitution-delimiter = "fg=#cad3f5";
        command-substitution-delimiter-unquoted = "fg=#cad3f5";
        process-substitution-delimiter = "fg=#cad3f5";
        back-quoted-argument-delimiter = "fg=#ed8796";
        back-double-quoted-argument = "fg=#ed8796";
        back-dollar-quoted-argument = "fg=#ed8796";
        command-substitution-quoted = "fg=#eed49f";
        command-substitution-delimiter-quoted = "fg=#eed49f";
        single-quoted-argument = "fg=#eed49f";
        single-quoted-argument-unclosed = "fg=#ee99a0";
        double-quoted-argument = "fg=#eed49f";
        double-quoted-argument-unclosed = "fg=#ee99a0";
        rc-quote = "fg=#eed49f";
        dollar-quoted-argument = "fg=#cad3f5";
        dollar-quoted-argument-unclosed = "fg=#ee99a0";
        dollar-double-quoted-argument = "fg=#cad3f5";
        assign = "fg=#cad3f5";
        named-fd = "fg=#cad3f5";
        numeric-fd = "fg=#cad3f5";
        unknown-token = "fg=#ee99a0";
        path = "fg=#cad3f5,underline";
        path_pathseparator = "fg=#ed8796,underline";
        path_prefix = "fg=#cad3f5,underline";
        path_prefix_pathseparator = "fg=#ed8796,underline";
        globbing = "fg=#cad3f5";
        history-expansion = "fg=#c6a0f6";
        back-quoted-argument-unclosed = "fg=#ee99a0";
        redirection = "fg=#cad3f5";
        arg0 = "fg=#cad3f5";
        default = "fg=#cad3f5";
        cursor = "fg=#cad3f5";
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
      # SEE https://github.com/catppuccin/starship/blob/main/starship.toml
      palette = "catppuccin_macchiato";
      palettes.catppuccin_macchiato = {
        rosewater = "#f4dbd6";
        flamingo = "#f0c6c6";
        pink = "#f5bde6";
        mauve = "#c6a0f6";
        red = "#ed8796";
        maroon = "#ee99a0";
        peach = "#f5a97f";
        yellow = "#eed49f";
        green = "#a6da95";
        teal = "#8bd5ca";
        sky = "#91d7e3";
        sapphire = "#7dc4e4";
        blue = "#8aadf4";
        lavender = "#b7bdf8";
        text = "#cad3f5";
        subtext1 = "#b8c0e0";
        subtext0 = "#a5adcb";
        overlay2 = "#939ab7";
        overlay1 = "#8087a2";
        overlay0 = "#6e738d";
        surface2 = "#5b6078";
        surface1 = "#494d64";
        surface0 = "#363a4f";
        base = "#24273a";
        mantle = "#1e2030";
        crust = "#181926";
      };
    };
  };
}
