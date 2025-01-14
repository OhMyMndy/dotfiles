{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      ${builtins.readFile "${./../../../.bashrc}"}
      . "$HOME/.asdf/asdf.sh"
      . "$HOME/.asdf/completions/asdf.bash"
    '';
  };
  home.file.".bashrc.d" = {
    source = ./../../../.bashrc.d;
    recursive = true;
  };
}
