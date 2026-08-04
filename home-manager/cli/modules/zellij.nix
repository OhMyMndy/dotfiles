{
  pkgs,
  config,
  dotfiles,
  ...
}:
{
  home.packages = with pkgs; [ zellij ];

  home.file.".config/zellij" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/zellij";
    recursive = true;
  };
}
