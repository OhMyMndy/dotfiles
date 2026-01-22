{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ (import ./asdf.nix) ];
  programs.zsh = {
    oh-my-zsh = {
      plugins = [ "golang" ];
    };
  };

  home.packages = with pkgs; [
    gnutar
    gzip
  ];
  home.activation.setupGolang = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="$PATH:${config.home.path}/bin:$HOME/.local/bin:$HOME/.asdf/shims"

    asdf plugin add golang >/dev/null
    asdf install golang latest >/dev/null
    asdf set -u golang latest
  '';
}
