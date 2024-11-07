{ pkgs, ... }:
{

  home.packages = with pkgs; [
    git
    fzf
    direnv
    starship
  ];

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "cursor"
      ];
      patterns = {
        "rm -rf *" = "fg=red,bold";
      };
    };

    history = {
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
      theme = "fishy";
    };

    initExtra = ''
      ${builtins.readFile "${./../../../.zshrc}"}
      # Make sure we use asdf versions of tools before tools installed on the
      # OS or via Nix
      ASDF_FORCE_PREPEND=yes
      . "$HOME/.asdf/asdf.sh"
      . "$HOME/.asdf/completions/asdf.bash"
    '';
    # SEE https://github.com/redyf/nixdots/blob/492aede6453d4f62fad6929a6281552504efbaa8/home/system/shell/default.nix#L184
    plugins =
      let
        themepkg = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "zsh-syntax-highlighting";
          rev = "7926c3d3e17d26b3779851a2255b95ee650bd928";
          hash = "sha256-l6tztApzYpQ2/CiKuLBf8vI2imM6vPJuFdNDSEi7T/o=";
        };
        fzf-tab = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "6aced3f35def61c5edf9d790e945e8bb4fe7b305";
          hash = "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=";
        };
      in
      with pkgs;
      [
          # TODO make this work
         {
              name = "fzf-tab";
              file = "fzf-tab.plugin.zsh";
              src = fzf-tab;
            }
        {
          name = "ctp-zsh-syntax-highlighting";
          src = themepkg;
          file = themepkg + "/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
        }
      ];
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
      git_status.disabled = true;
      gcloud.disabled = false;
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
