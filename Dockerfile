FROM archlinux/archlinux:base-devel

RUN pacman -Syu --needed --noconfirm git

# makepkg user and workdir
ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install yay
RUN git clone https://aur.archlinux.org/yay.git \
  && cd yay \
  && makepkg -sri --needed --noconfirm \
  && cd \
  # Clean up
  && rm -rf .cache yay


COPY ./pacman-packages.txt /tmp/pacman-packages.txt
RUN sudo pacman -Sy --noconfirm $(cat /tmp/pacman-packages.txt) \
    && sudo find /var/cache/pacman/pkg -mindepth 1 -delete
    
COPY ./aur-packages.txt /tmp/aur-packages.txt
RUN yay -Sy --needed --noconfirm $(cat /tmp/aur-packages.txt) \
    && sudo find /var/cache/pacman/pkg -mindepth 1 -delete


COPY ./pacman-distrobox-packages.txt /tmp/pacman-distrobox-packages.txt
RUN sudo pacman -Sy --noconfirm $(cat /tmp/pacman-distrobox-packages.txt) \
    && sudo find /var/cache/pacman/pkg -mindepth 1 -delete
    