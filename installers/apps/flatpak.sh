#!/usr/bin/env bash


install() {
  flatpak install --from -y "$@"
}

flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub org.gimp.GIMP
flatpak install -y flathub org.darktable.Darktable



# Decide to use
# flatpak install flathub org.videolan.VLC -y

flatpak install -y flathub com.transmissionbt.Transmission
flatpak install -y flathub com.github.rssguard -y
flatpak install -y flathub org.gnome.Rhythmbox3 -y
flatpak install -y flathub org.remmina.Remmina
flatpak install -y flathub com.github.wwmm.pulseeffects
# flatpak install -y flathub org.pitivi.Pitivi
flatpak install -y flathub org.musicbrainz.Picard
flatpak install -y flathub work.openpaper.Paperwork
# flatpak install -y flathub org.kde.okular
flatpak install -y flathub org.gnome.meld
# flatpak install -y flathub org.kicad_pcb.KiCad
# flatpak install -y flathub org.kde.krita
