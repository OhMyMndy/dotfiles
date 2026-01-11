{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # ansible-language-server
    ansible-lint
    ansible-doctor
  ];

}
