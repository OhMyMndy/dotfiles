{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      ${builtins.readFile "${./../../../.bashrc}"}
      if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
        . "$HOME/.asdf/asdf.sh"
        . "$HOME/.asdf/completions/asdf.bash"
      fi
    '';
  };
  home.file.".bashrc.d" = {
    source = ./../../../.bashrc.d;
    recursive = true;
  };
}
