{
  pkgs,
  config,
  lib,
  ...
}: {
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
    . ~/.asdf/asdf.sh
    asdf plugin add nodejs >/dev/null
    # asdf install nodejs latest
    # asdf global nodejs latest

    asdf install nodejs $(asdf list all nodejs | grep '^22.' | tail -1) >/dev/null
    asdf global nodejs $(asdf list all nodejs | grep '^22.' | tail -1)
  '';
}
