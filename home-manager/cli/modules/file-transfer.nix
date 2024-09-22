{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rsync
    rclone
  ];

  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        "cp"
        "rsync"
      ];
    };
  };
}
