{ pkgs, lib, ... }:
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
    crane
    crc # openshift, development purposes
    cri-tools
    dive
    # fluxctl
    # graphviz
    # helmfile
    # hubble
    # kubectl
    # kind
    # myHelm
    # myHelmfile
    # kubernetes-helm # TODO: install with plugins, but from Nix cache
    # helmfile # TODO
    istioctl
    karmor
    kubeconform
    kubeswitch # switcher command
    # kustomize
    kompose
    # k3s # k3s, kubectl
    # k3d
    # k9s
    openshift
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
    export PATH="$${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

    pkgs="argocd argocd-autopilot copa minikube kubectl krew opa helm cilium hubble trivy jq yq talosctl kubectx kubens k9s kustomize helmfile"
    for pkg in $pkgs; do
      if [[ ! -f ~/.arkade/bin/"$pkg" ]]; then
        ${pkgs.arkade}/bin/arkade get $pkg --quiet
      fi
    done

    ${pkgs.arkade}/bin/arkade get helm@v3.20.0
    #if ! ~/.arkade/bin/helm plugin list | tail -n +2 | cut -f1 | grep -q helm-git; then
    #  ~/.arkade/bin/helm plugin install https://github.com/aslafy-z/helm-git --version 1.3.0
    #fi

    pkgs="envsubst cert-manager graph kubescape kyverno"
    for pkg in $pkgs; do
      # suppress "add the following to your ~/.zshrc" warning
      ~/.arkade/bin/krew install "$pkg" &>/dev/null
    done
  '';
}
