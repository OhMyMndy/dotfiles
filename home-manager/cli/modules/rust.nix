{ pkgs, lib, ... }:
{
  programs.zsh = {
    oh-my-zsh = {
      plugins = [ "rust" ];
    };
  };

  home.packages = with pkgs; [
    lldb # High performance debugger
  ];

  home.activation.setupRust = lib.hm.dag.entryAfter [ "installPackages" ] ''
    . ~/.asdf/asdf.sh
    ${pkgs.asdf-vm}/bin/asdf plugin add rust
    ${pkgs.asdf-vm}/bin/asdf install rust latest
    ${pkgs.asdf-vm}/bin/asdf global rust latest
    rustup component add rust-analyzer
  '';

}
