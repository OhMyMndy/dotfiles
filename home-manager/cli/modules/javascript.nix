{ pkgs, ... }:
{

  home.packages = with pkgs; [
    nvm
  ];

  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        "nvm"
        "npm"
      ];
    };
  };
}
