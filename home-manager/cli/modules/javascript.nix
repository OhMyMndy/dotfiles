{
  pkgs,
  config,
  lib,
  ...
}:
{
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

  home.activation.setupNodejs = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
    . ~/.asdf/asdf.sh
    ${pkgs.asdf-vm}/bin/asdf plugin add nodejs
    # ${pkgs.asdf-vm}/bin/asdf install nodejs latest
    # ${pkgs.asdf-vm}/bin/asdf global nodejs latest

    ${pkgs.asdf-vm}/bin/asdf install nodejs $(${pkgs.asdf-vm}/bin/asdf list all nodejs | grep '^22.' | tail -1)
    ${pkgs.asdf-vm}/bin/asdf global nodejs $(${pkgs.asdf-vm}/bin/asdf list all nodejs | grep '^22.' | tail -1)
  '';
}
