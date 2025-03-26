{
  pkgs,
  lib,
  config,
  ...
}:
{
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
    PATH="${config.home.path}/bin:$PATH"
    if [[ ! -d ~/.local/bin/ ]]; then
      ${pkgs.curl}/bin/curl -SsL https://github.com/asdf-vm/asdf/releases/download/v0.16.6/asdf-v0.16.6-linux-arm64.tar.gz | ${pkgs.gnutar}/bin/tar xz -C ~/.local/bin/
    fi
    #~/.local/bin/asdf plugin add dprint https://github.com/asdf-community/asdf-dprint
    #~/.local/bin/asdf set -u dprint latest
  '';
}
