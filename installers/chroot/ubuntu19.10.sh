#!/usr/bin/env bash

set -e


set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1
# shellcheck source=../../.base-script.sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../../.base-script.sh"

dir_name="$1"

if [[ $dir_name = '' ]]; then
    echo "No dir name provided"
    exit 2
fi

mkdir -p "$HOME/jails"
cd "$HOME/jails" || exit 99


if [[ ! -d "$dir_name" ]]; then
    mkdir "$dir_name"
    cd "$dir_name" || exit 98
    curl -LsS "http://cdimage.ubuntu.com/ubuntu-base/releases/19.10/release/ubuntu-base-19.10-base-$(cpu_architecture_simple).tar.gz" | tar xz
else
    cd "$dir_name" || exit 98
fi



# USER=mandy-chroot
proot_run "export DEBIAN_FRONTEND=\"noninteractive\"; apt update -qq; apt upgrade -y -qq; apt install -y -qq iproute2 git zsh readline-common vim curl python3-pip less; pip3 install -q dockerfile"

proot_run "export DEBIAN_FRONTEND=\"noninteractive\"; apt install -y -qq less qemu libegl1 libgl1-mesa-dri libgl1-mesa-glx qemu-kvm qemu-system-x86"
proot_run "export DEBIAN_FRONTEND=\"noninteractive\"; apt install -y -qq augeas-tools augeas-lenses  libxcb-xinput0 xserver-xorg-video-intel xserver-xorg-video-ati cgroup-tools"
proot_run "export DEBIAN_FRONTEND=\"noninteractive\"; apt install -y -qq qemu qemu-kvm qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils openssl ca-certificates pm-utils dbus-x11 virt-manager libgl1-mesa-dri libgl1-mesa-glx libpango1.0-0 libegl1"

# openssh-server openssh-client man


# bash -c "old_home=\"$HOME\"; HOME=''; USER=mandy-chroot; proot -b \"\$old_home:/old_home\" -S . /bin/bash"
#   bash -c "$(/old_home/bin/dockerfile_to_bash /old_home/src/dockerfiles/dockerfiles/ubuntu/Dockerfile)"

qemu-virgil -enable-kvm -m 512 -device virtio-vga,virgl=on -display sdl,gl=on  -netdev user,id=ethernet.0,hostfwd=tcp::10022-:22 -device rtl8139,netdev=ethernet.0 -soundhw ac97

proot_run  "apt update -qq; apt upgrade -y -qq; apt install -y -qq less qemu libegl1 libgl1-mesa-dri libgl1-mesa-glx qemu-kvm qemu-system-x86"
# docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --privileged -v "${HOME}:${HOME}:ro" ubuntu:19.10
# qemu-system-x86_64 -enable-kvm -cpu host -device virtio-serial-pci -boot d -cdrom /data/xubuntu-18.04.3-desktop-amd64.iso -vga virtio -display gtk,gl=on -m 1024  -usb -device usb-tablet -show-cursor


# qemu-system-x86_64 -enable-kvm -cpu host -device virtio-serial-pci -boot d -cdrom /home/mandy/Downloads/xubuntu-18.04.3-desktop-amd64.iso -vga virtio -display gtk,gl=on -m 1024  -usb -device usb-tablet -show-cursor