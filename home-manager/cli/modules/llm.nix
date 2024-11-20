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
    llmWithPlugins
  ];
  home.activation.setupLlm = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ${pkgs.bitwarden-cli}/bin/bw unlock --check &>/dev/null; then
      ${llmWithPlugins}/bin/llm keys set openrouter \
        --value "$(${pkgs.bitwarden-cli}/bin/bw get item OpenRouter | ${pkgs.jq}/bin/jq '.fields[] | select(.name =="API KEY") | .value' -r)"
    fi
  '';
}
