let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  packageOverrides = pkgs: with pkgs; {
    ohmymndy-core = pkgs.buildEnv {
      name = "OhMyMndy Core";
      paths = [
        less
        jq
	yq
	ripgrep
	git
	tig
	gh
	tree
	tmux
	neovim
	tree-sitter
	gcc
	yamllint
	python310Packages.python-lsp-server
  sumneko-lua-language-server
  stylua
	shellcheck
	hadolint
	lazygit
	zsh
	oh-my-zsh
	fzf
	fzf-zsh
	xstow
      ];
    };
    ohmymndy-diagnostics = pkgs.buildEnv {
      name = "OhMyMndy Diagnostics";
      paths = [
        nmap
	iputils
	traceroute
	iotop
      ];
    };
    ohmymndy-containers = pkgs.buildEnv {
      name = "OhMyMndy Containers";
      paths = [
	podman
  buildah
  unstable.nomad_1_4
  nomad-driver-podman
  fuse-overlayfs
  slirp4netns
  waypoint
  shadow
  consul
  vault
  driftctl
      ];
    };
    ohmymndy-infra = pkgs.buildEnv {
      name = "OhMyMndy Infra";
      paths = [
        google-cloud-sdk
	terraform
	terraform-ls
	terraform-lsp
      ];
    };
    ohmymndy-dev = pkgs.buildEnv {
      name = "OhMyMndy Dev";
      paths = [
        go
	rustup
	nodejs
  ruby
  sqlite
	nodePackages.pnpm
  gnumake
  nodePackages.bash-language-server
  nodePackages.typescript-language-server
  shfmt
      ];
    };
    ohmymndy-dev-gui = pkgs.buildEnv {
      name = "OhMyMndy Dev GUI";
      paths = [ 
        vscode
	(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
	vivaldi
	vivaldi-widevine
	vivaldi-ffmpeg-codecs
      ];
    };
  };
}
