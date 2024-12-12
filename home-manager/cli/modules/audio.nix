{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    streamrip
  ];

  home.activation.setupAudio = lib.hm.dag.entryAfter [ "installPackages" ] ''
    PATH="${config.home.path}/bin:$PATH"
  '';
}
