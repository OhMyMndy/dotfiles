#!/usr/bin/env bash

if command -v apt-get &>/dev/null; then
  sudo apt-get install -y \
    btrfs-progs \
    crun \
    git \
    golang-go \
    go-md2man \
    iptables \
    libassuan-dev \
    libbtrfs-dev \
    libc6-dev \
    libdevmapper-dev \
    libglib2.0-dev \
    libgpgme-dev \
    libgpg-error-dev \
    libprotobuf-dev \
    libprotobuf-c-dev \
    libseccomp-dev \
    libselinux1-dev \
    libsystemd-dev \
    netavark \
    pkg-config \
    uidmap

  mkdir -p src
  if [[ ! -d podman ]]; then
    git clone https://github.com/containers/podman.git
  fi
  cd podman || exit
  git pull
  make BUILDTAGS="selinux seccomp apparmor cni systemd" PREFIX=/usr
  sudo make install PREFIX=/usr
fi
#
#mkdir -p /etc/systemd/system/user@.service.d
#cat >/etc/systemd/system/user@.service.d/delegate.conf <<EOF
#[Service]
#Delegate=cpu cpuset io memory pids
#EOF
#systemctl daemon-reload
#touch /etc/containers/nodocker
