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
      plugins = [ "rust" ];
    };
  };

  home.packages = with pkgs; [ ];

  home.activation.setupRust = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="$PATH:${config.home.path}/bin:$HOME/.local/bin:$HOME/.asdf/shims"
    PATH+="${pkgs.gcc}/bin"

    asdf plugin add rust >/dev/null
    asdf install rust latest >/dev/null
    asdf set -u rust latest
    rustup component add rust-analyzer >/dev/null
  '';
}
