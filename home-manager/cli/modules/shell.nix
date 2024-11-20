{ pkgs
, lib
, home
, ...
}:
let
  llm-openrouter = pkgs.callPackage ../../../packages/llm-openrouter/default.nix { };
  llmWithPlugins = pkgs.llm.withPlugins [ llm-openrouter ];
in
{
  home.packages = with pkgs; [
    aria2
    atuin
    bat # TODO https://github.com/catppuccin/bat
    cpulimit
    curl
    gawk
    bat
    devenv # https://devenv.sh
    dialog
    eza # https://github.com/eza-community/eza
    hadolint
    ijq
    jless
    jq
    just
    llmWithPlugins
    lm_sensors
    p7zip
    restic
    shellcheck
    shfmt
    sqlite
    tree
    yq
    wget
  ];

  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nushell = {
    enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };

  home.file.".inputrc" = {
    source = ./../../../.inputrc;
  };

  home.activation.setupLlm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ${pkgs.bitwarden-cli}/bin/bw unlock --check &>/dev/null; then
      ${llmWithPlugins}/bin/llm keys set openrouter \
        --value "$(${pkgs.bitwarden-cli}/bin/bw get item OpenRouter | ${pkgs.jq}/bin/jq '.fields[] | select(.name =="API KEY") | .value' -r)"
    fi
  '';
}
