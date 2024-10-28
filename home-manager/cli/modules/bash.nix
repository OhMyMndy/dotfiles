{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      ${builtins.readFile "${./../../../.bashrc}"}
      . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
      . "${pkgs.asdf-vm}/share/asdf-vm/completions/asdf.bash"
    '';
    # bashrcExtra = builtins.readFile "${./../../../.bashrc}";
  };
  home.file.".bashrc.d" = {
    source = ./../../../.bashrc.d;
    recursive = true;
  };

}
