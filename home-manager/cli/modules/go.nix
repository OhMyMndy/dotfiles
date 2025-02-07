{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.zsh = {
    oh-my-zsh = {
      plugins = ["golang"];
    };
  };

  home.packages = with pkgs; [
    gnutar
    gzip
  ];
  home.activation.setupGolang = lib.hm.dag.entryAfter ["installPackages"] ''
    PATH="${config.home.path}/bin:$PATH"
    . ~/.asdf/asdf.sh
    asdf plugin add golang >/dev/null
    asdf install golang latest >/dev/null
    asdf global golang latest
  '';
}
