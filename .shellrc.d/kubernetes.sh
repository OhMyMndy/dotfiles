# shellcheck shell=bash

# kubectl config get-contexts

# kubectl config get-clusters

function kubectl() {
  local args=()
  [[ -n "$KUBECONTEXT" ]] && args+=(--context="$KUBECONTEXT")
  [[ -n "$KUBECLUSTER" ]] && args+=(--cluster="$KUBECLUSTER")
  command kubectl "${args[@]}" "$@"
}

function oc() {
  local args=()
  [[ -n "$KUBECONTEXT" ]] && args+=(--context="$KUBECONTEXT")
  [[ -n "$KUBECLUSTER" ]] && args+=(--cluster="$KUBECLUSTER")
  command oc "${args[@]}" "$@"
}
