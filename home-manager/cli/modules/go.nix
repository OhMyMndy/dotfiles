{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        "golang"
      ];
    };
  };

  home.packages = with pkgs; [
    gnutar
    gzip
  ];
  home.activation.setupgolang = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
    ${pkgs.asdf-vm}/bin/asdf plugin add golang
    ${pkgs.asdf-vm}/bin/asdf install golang
    ${pkgs.asdf-vm}/bin/asdf install golang latest
    ${pkgs.asdf-vm}/bin/asdf global golang latest
  '';

}
