if [[ -f "$XDG_RUNTIME_DIR/podman/podman.sock" ]]; then
  export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
fi
