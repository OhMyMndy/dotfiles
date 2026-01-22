{ pkgs, lib, ... }:
{
  imports = [ (import ./starship.nix) ];

  home.packages = with pkgs; [
    nodePackages_latest.bash-language-server
    shfmt
    shellcheck
  ];

  programs.bash = {
    enable = true;

    bashrcExtra = ''
      ${builtins.readFile "${./../../../.bashrc}"}
    '';
  };

  home.file.".bashrc.d" = {
    source = ./../../../.bashrc.d;
    recursive = true;
  };
}
