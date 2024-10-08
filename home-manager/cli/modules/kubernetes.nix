{ pkgs, ... }:
{

  home.packages = with pkgs; [
    kubernetes-helm
    k3s # k3s, kubectl
    k9s
    talosctl
    kubectx
  ];

  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        "helm"
        "kubectl"
        "kubectx"
      ];
    };
  };
}
