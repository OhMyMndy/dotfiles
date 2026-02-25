{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ (import ./sh.nix) ];

  home.packages = with pkgs; [
    # asdf-vm
  ];

  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        # "asdf"
      ];
    };
  };

  home.activation.setupAsdf = lib.hm.dag.entryAfter [ "installPackages" ] ''

    PATH="$PATH:${config.home.path}/bin:${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin"

    if [[ ! -f ~/.local/bin/asdf ]]; then
      mkdir -p ~/.local/bin/
      curl -SsL https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-amd64.tar.gz | tar xz -C ~/.local/bin/
      rm -rf ~/.asdf
    fi

    #~/.local/bin/asdf plugin add dprint https://github.com/asdf-community/asdf-dprint
    #~/.local/bin/asdf set -u dprint latest
  '';
}
