{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (import ./asdf.nix)
  ];
  programs.zsh = {
    oh-my-zsh = {
      plugins = [ "rust" ];
    };
  };

  home.packages = with pkgs; [ ];

  home.activation.setupRust = lib.hm.dag.entryAfter [ "installPackages" ] ''
    . ~/.asdf/asdf.sh
    asdf plugin add rust >/dev/null
    asdf install rust latest >/dev/null
    asdf global rust latest
    rustup component add rust-analyzer >/dev/null
  '';
}
