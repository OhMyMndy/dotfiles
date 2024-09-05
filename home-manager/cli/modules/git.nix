{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    delta
    git
    gitkraken
    gh
    lazygit
    tig
  ];

  programs.git = {
    enable = true;
  };

  home.file.".config/lazygit" = {
    source = config.lib.file.mkOutOfStoreSymlink ./../../../.config/lazygit;
  };

  home.file.".gitconfig-delta" = {
    source = config.lib.file.mkOutOfStoreSymlink ./../../../.gitconfig-delta;
  };

}
