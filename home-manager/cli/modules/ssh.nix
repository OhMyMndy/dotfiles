{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
  ];

  home.activation.seupSSH = lib.hm.dag.entryAfter [ "installPackages" ] ''
    mkdir -p ~/.ssh/
    touch ~/.ssh/config

    if ! grep -q "Include conf.d" ~/.ssh/config; then
      cat <<EOF | tee -a ~/.ssh/config >/dev/null
    Include conf.d/*
    EOF
    fi

    if ! grep -q TERM= ~/.ssh/config; then
      cat <<EOF | tee -a ~/.ssh/config > /dev/null
    Host *
      SetEnv TERM=xterm-256color
    EOF
    fi
  '';
}
