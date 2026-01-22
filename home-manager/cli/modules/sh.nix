{ pkgs, lib, ... }:
{

  home.file.".shellrc.d" = {
    source = ./../../../.shellrc.d;
    recursive = true;
  };

  home.file.".profile" = lib.mkForce { source = ./../../../.profile; };
}
