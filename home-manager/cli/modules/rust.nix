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
        "rust"
      ];
    };
  };

  home.activation.setupRust = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
    ${pkgs.asdf-vm}/bin/asdf plugin add rust
    ${pkgs.asdf-vm}/bin/asdf install rust
    ${pkgs.asdf-vm}/bin/asdf install rust latest
    ${pkgs.asdf-vm}/bin/asdf global rust latest
  '';

}
