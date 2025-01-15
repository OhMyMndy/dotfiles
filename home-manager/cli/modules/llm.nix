{ pkgs, lib, ... }:
let
  llm-openrouter = pkgs.callPackage ../../../packages/llm-openrouter/default.nix { };
  llm-jq = pkgs.callPackage ../../../packages/llm-jq/default.nix { };
  llmWithPlugins = pkgs.python3.withPackages (ps: [
    ps.llm
    llm-openrouter
    llm-jq
  ]);
in
{
  home.packages = [ llmWithPlugins ];
  home.activation.setupLlm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ${pkgs.bitwarden-cli}/bin/bw unlock --check &>/dev/null; then
      ${llmWithPlugins}/bin/llm keys set openrouter \
        --value "$(${pkgs.bitwarden-cli}/bin/bw get item OpenRouter | ${pkgs.jq}/bin/jq '.fields[] | select(.name =="API KEY") | .value' -r)"
    fi
  '';
}
