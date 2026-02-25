{ ... }:
{

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "22.11";
  };

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  news.display = "silent";
  xdg = {
    enable = true;
    mime.enable = true;
  };
}
