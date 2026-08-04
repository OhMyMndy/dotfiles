{
  pkgs,
  lib,
  config,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [
  ];

  home.activation.setupCodium = lib.hm.dag.entryAfter [ "installPackages" ] ''
    if [[ command -v codium &>/dev/null ]]; then
      codium --install-extension k--kato.intellij-idea-keybindings \
      --install-extension hashicorp.terraform \
      --install-extension mermaidchart.vscode-mermaid-chart \
      --install-extension xyz.local-history \
      --install-extension sst-dev.opencode \
      --install-extension redhat.vscode-yaml \
      --install-extension ms-python.python \
      --install-extension pkief.material-icon-theme \
      --install-extension golang.go \
      --install-extension ms-kubernetes-tools.vscode-kubernetes-tools \
      --install-extension redhat.vscode-openshift-connector \
      --install-extension jnoortheen.nix-ide
    fi
  '';
}
