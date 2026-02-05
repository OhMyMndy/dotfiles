{ pkgs, lib, inputs,... }:
{
  imports = [ (import ./starship.nix) ];

  home.packages = with pkgs; [
    inputs.flox.packages.${pkgs.system}.default
    nodePackages_latest.bash-language-server
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
    source = ./../../../.bashrc.d;
    recursive = true;
  };
}
