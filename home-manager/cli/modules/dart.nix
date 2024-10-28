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
        "flutter"
      ];
    };
  };

  home.activation.setupDart = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
    ${pkgs.asdf-vm}/bin/asdf plugin add flutter
    ${pkgs.asdf-vm}/bin/asdf install flutter
    ${pkgs.asdf-vm}/bin/asdf install flutter latest
    ${pkgs.asdf-vm}/bin/asdf global flutter latest
  '';

}
