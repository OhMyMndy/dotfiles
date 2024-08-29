{ config, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # disable fish greeting
      set fish_greeting
      fish_config theme choose tokyonight
      fish_add_path -p ~/.nix-profile/bin /nix/var/nix/profiles/default/bin

      set fish_cursor_default     block      blink
      set fish_cursor_insert      line       blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_visual      block

      set -g fish_key_bindings fish_vi_key_bindings
      bind -M insert \cc kill-whole-line repaint
    '';
  };

  home.file."./.config/fish/fish_variables" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/fish_variables";
  };
}
