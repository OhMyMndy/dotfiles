{pkgs, ...}: let
  myHelm = pkgs.wrapHelm pkgs.kubernetes-helm {
    plugins = with pkgs.kubernetes-helmPlugins; [
      helm-secrets
      helm-diff
      helm-s3
      helm-git
    ];
  };

  myHelmfile = pkgs.helmfile-wrapped.override {inherit (myHelm.passthru) pluginsDir;};
in {
  home.packages = with pkgs; [
    cilium-cli
    # myHelm
    # myHelmfile
    karmor
    kubeconform
    kustomize
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
