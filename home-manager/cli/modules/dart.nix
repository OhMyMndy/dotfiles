{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ (import ./asdf.nix) ];
  # TODO: install flutter dependencies
  # sudo dnf install -y bash curl file git unzip which xz zip mesa-libGLU clang cmake ninja-build pkg-config gtk3-devel

  home.packages = with pkgs; [
    curl
    gnutar
    jq
    xz
  ];
  programs.zsh = {
    oh-my-zsh = {
      plugins = [ "flutter" ];
    };
  };

  home.activation.setupDart = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # util-linux contains rev
    PATH="$PATH:${config.home.path}/bin:$HOME/.local/bin:$HOME/.asdf/shims:${pkgs.util-linux}/bin"
    asdf plugin add flutter >/dev/null
    asdf install flutter latest >/dev/null
    asdf set -u flutter latest

    asdf plugin add dart >/dev/null
    asdf install dart latest >/dev/null
    asdf set -u dart latest
  '';

  home.file.".zshrc.d/dart.sh" = {
    text = ''
      export PATH="$PATH":"$HOME/.pub-cache/bin"
    '';
  };
}
