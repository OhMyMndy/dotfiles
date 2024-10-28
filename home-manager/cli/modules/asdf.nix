{
  pkgs,
  lib,
  config,
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

  
  home.activation.setupAsdf = lib.hm.dag.entryAfter [ "installPackages" ] ''
    # PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:${config.home.path}/bin:$PATH"
    PATH="${config.home.path}/bin:$PATH"
    . "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh"
    ${pkgs.asdf-vm}/bin/asdf plugin add uv
    ${pkgs.asdf-vm}/bin/asdf install uv
    ${pkgs.asdf-vm}/bin/asdf install uv latest
    ${pkgs.asdf-vm}/bin/asdf global uv latest
  '';

}
