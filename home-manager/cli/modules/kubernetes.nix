{
  pkgs,
  lib,
  ...
}:
# let
# myHelm = pkgs.wrapHelm pkgs.kubernetes-helm {
#   plugins = with pkgs.kubernetes-helmPlugins; [
#     helm-secrets
#     helm-diff
#     helm-s3
#     helm-git
#   ];
# };
#
# myHelmfile = pkgs.helmfile-wrapped.override {inherit (myHelm.passthru) pluginsDir;};
# in
{
  home.packages = with pkgs; [
    arkade
    # cilium-cli
    cri-tools
    fluxctl
    # graphviz
    # helmfile
    # hubble
    # kubectl
    # kind
    # myHelm
    # myHelmfile
    # kubernetes-helm # TODO: install with plugins, but from Nix cache
    # helmfile # TODO
    karmor
    kubeconform
    # kustomize
    kompose
    # k3s # k3s, kubectl
    # k3d
    # k9s
    # minikube
    # talosctl
    # kubectx
    skaffold
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

  # TODO: install with arkade:
  # sudo $(command -v) system install cni
  # sudo $(command -v) system install tc-redirect-tap
  home.activation.setupKubernetes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    pkgs="minikube kubectl krew helm cilium hubble trivy jq yq talosctl kubectx kubens k9s kustomize helmfile"
    for pkg in $pkgs; do
      if [[ ! -f ~/.arkade/bin/"$pkg" ]]; then
        ${pkgs.arkade}/bin/arkade get $pkg --quiet
      fi
    done
    if ! ~/.arkade/bin/helm plugin list | tail -n +2 | cut -f1 | grep -q helm-git; then
      ~/.arkade/bin/helm plugin install https://github.com/aslafy-z/helm-git --version 1.3.0
    fi
    pkgs="envsubst cert-manager graph kubescape kyverno"
    for pkg in $pkgs; do
      ~/.arkade/bin/krew install "$pkg" >/dev/null
    done
  '';
}
