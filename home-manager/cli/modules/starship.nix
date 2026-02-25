{ pkgs, lib, ... }:
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
      direnv.disabled = false;
      format = "\${custom.wsl_distro}$all";
      custom.wsl_distro = {
        command = "echo $WSL_DISTRO_NAME";
        when = ''test -n "$WSL_DISTRO_NAME"'';
        os = "linux";
        style = "bold white";
      };
      git_status.disabled = true;
      gcloud.disabled = true;
      kubernetes = {
        disabled = false;
#        detect_files = [
#          "kustomization.yaml"
#          "kustomization.yml"
#        ];
        detect_env_vars = [ "KUBECONFIG" ];
      };
    };
  };

  home.file.".zshrc.d" = {
    source = ./../../../.zshrc.d;
    recursive = true;
  };
}
