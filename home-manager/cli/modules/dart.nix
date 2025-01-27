{
  pkgs,
  lib,
  config,
  ...
}:
{
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
    PATH="${config.home.path}/bin:$PATH"
    . ~/.asdf/asdf.sh
    asdf plugin add flutter
    asdf install flutter latest
    asdf global flutter latest
  '';

  home.file.".zshrc.d/dart.sh" = {
    text = ''
      export PATH="$PATH":"$HOME/.pub-cache/bin"
    '';
  };
}
