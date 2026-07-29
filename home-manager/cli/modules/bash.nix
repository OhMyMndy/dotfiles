{ pkgs, lib, config, dotfiles, ... }:
{
  imports = [ (import ./starship.nix) ];

  home.packages = with pkgs; [
    flox.flox
    bash-language-server
    shfmt
    shellcheck
  ];

  programs.bash = {
    enable = true;
    package = null;
    bashrcExtra = ''
      ${builtins.readFile "${./../../../.bashrc}"}
    '';
  };

  home.file.".bashrc.d" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.bashrc.d";
    recursive = true;
  };
}
