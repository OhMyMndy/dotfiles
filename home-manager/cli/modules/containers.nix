{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    act
    distrobox
    hadolint
  ];

  home.activation.setupPodman = lib.hm.dag.entryAfter ["installPackages"] ''
    if command -v systemctl &>/dev/null; then
      if systemctl list-sockets --user --all | grep podman.socket >/dev/null; then
        systemctl enable --now --user podman.socket
      fi
    fi
  '';

  programs.zsh = {
    oh-my-zsh = {
      plugins = ["podman"];
    };
  };
}
