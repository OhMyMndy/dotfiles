{
  pkgs,
  lib,
  config,
  ...
}: {
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

  home.activation.setupAsdf = lib.hm.dag.entryAfter ["installPackages"] ''
    PATH="${config.home.path}/bin:$PATH"
    if [[ ! -d ~/.asdf ]]; then
      ${pkgs.git}/bin/git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
    fi
  '';
}
