{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    asdf-vm
  ];

  programs.zsh = {
    oh-my-zsh = {
      plugins = [
        # "asdf"
      ];
    };
  };

}
