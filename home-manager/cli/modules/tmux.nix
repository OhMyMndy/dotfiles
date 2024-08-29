{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmux
  ];
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = builtins.readFile ./../../../.tmux.conf;
  };

}
