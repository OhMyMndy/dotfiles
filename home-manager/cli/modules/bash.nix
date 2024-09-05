{ ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile "${./../../../.bashrc}";
  };
  home.file.".bashrc.d" = {
    source = ./../../../.bashrc.d;
    recursive = true;
  };


}
