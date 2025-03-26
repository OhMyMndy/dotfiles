{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    (import ./asdf.nix)
  ];
  home.packages = with pkgs; [
    # nvm
  ];

  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        # "nvm"
        "npm"
      ];
    };
  };

  home.activation.setupNodejs = lib.hm.dag.entryAfter ["installPackages"] ''
    PATH="${config.home.path}/bin:$PATH"
    PATH+=":$HOME/.local/bin:$HOME/.asdf/shims:$PATH"
    asdf plugin add nodejs >/dev/null
    # asdf install nodejs latest
    # asdf set -u nodejs latest

    asdf install nodejs $(asdf list all nodejs | grep '^22.' | tail -1) >/dev/null
    asdf set -u nodejs $(asdf list all nodejs | grep '^22.' | tail -1)
  '';
}
