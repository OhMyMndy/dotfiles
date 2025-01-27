{
  pkgs,
  lib,
  ...
}:
{
  programs.zsh = {
    oh-my-zsh = {
      plugins = [ "rust" ];
    };
  };

  home.packages = with pkgs; [ ];

  home.activation.setupRust = lib.hm.dag.entryAfter [ "installPackages" ] ''
    . ~/.asdf/asdf.sh
    asdf plugin add rust
    asdf install rust latest
    asdf global rust latest
    rustup component add rust-analyzer
  '';
}
