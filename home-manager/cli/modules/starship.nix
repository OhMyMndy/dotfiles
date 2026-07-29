{ pkgs, lib, config, dotfiles, ... }:
{
  home.packages = with pkgs; [ starship ];

  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      plugins = [ "starship" ];
    };
  };

  programs.starship = {
    enable = true;
    # SEE https://starship.rs/config/#default-prompt-format
    settings = {
      directory = {
        truncate_to_repo = false;
        truncation_length = 5;
      };
      direnv.disabled = false;
      format = "\${custom.wsl_distro}\${custom.kube_env}$all";
      custom.wsl_distro = {
        command = "echo $WSL_DISTRO_NAME";
        when = ''test -n "$WSL_DISTRO_NAME"'';
        os = "linux";
        style = "bold white";
      };
      custom.kube_env = {
        command = ''
            if [ -n "$KUBECONTEXT" ] && [ -n "$KUBECLUSTER" ]; then
              echo "$KUBECONTEXT/$KUBECLUSTER"
            elif [ -n "$KUBECONTEXT" ]; then
              echo "$KUBECONTEXT"
            elif [ -n "$KUBECLUSTER" ]; then
              echo "$KUBECLUSTER"
            else
              timeout 0.2 kubectl config current-context 2>/dev/null
            fi
          '';
        when = ''command -v kubectl >/dev/null 2>&1'';
        symbol = "☸ ";
        style = "bold cyan";
        format = "[$symbol($output\n)]($style)";
      };
      git_status.disabled = true;
      gcloud.disabled = true;
      kubernetes = {
        disabled = true;
        #        detect_files = [
        #          "kustomization.yaml"
        #          "kustomization.yml"
        #        ];
        detect_env_vars = [ "KUBECONFIG" "KUBECLUSTER" "KUBECONTEXT"];
      };
    };
  };

  home.file.".zshrc.d" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.zshrc.d";
    recursive = true;
  };
}
