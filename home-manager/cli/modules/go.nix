{
  pkgs,
  lib,
  config,
  ...
}:
{
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
    PATH="${config.home.path}/bin:$PATH"
    . ~/.asdf/asdf.sh
    ${pkgs.asdf-vm}/bin/asdf plugin add golang
    ${pkgs.asdf-vm}/bin/asdf install golang latest
    ${pkgs.asdf-vm}/bin/asdf global golang latest
  '';
}
