{pkgs, ...}: {
    home.username = "vscode";
    home.homeDirectory = "/home/vscode";
    home.stateVersion = "22.11"; # To figure this out you can comment out the line and see what version it expected.
    programs.home-manager.enable = true;
    home.packages = with pkgs; [
        # sudo $(which podman) image trust set -t reject default
        # sudo $(which podman) image trust set --type accept docker.io
        podman
        distrobox
        k3s

        neovim
        hadolint
        shellcheck
    ];
  programs.zsh = {    
    enable = true;    
    oh-my-zsh = {    
      enable = true;    
      plugins = [    
        "git"    
      ];    
      theme = "robbyrussell";    
    };    
    initExtra = ''    
      bindkey  "^[[H"   beginning-of-line    
      bindkey  "^[[F"   end-of-line    
      eval "$(direnv hook zsh)"    
    '';    
                      
  };   
}
