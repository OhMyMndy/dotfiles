{ pkgs, ... }:
{
  imports = [
    (import ./starship.nix)
  ];

  programs.bash = {
    enable = true;
    package = pkgs.emptyDirectory;

    bashrcExtra = ''
      ${builtins.readFile "${./../../../.bashrc}"}
    '';
  };


  home.file.".bashrc.d" = {
    source = ./../../../.bashrc.d;
    recursive = true;
  };
}
