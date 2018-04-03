#!/usr/bin/env bash


install() {
  flatpak install --from -y "$@"
}

flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#install https://flathub.org/repo/appstream/io.atom.Atom.flatpakref
#install https://flathub.org/repo/appstream/org.darktable.Darktable.flatpakref
#install https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref
#flatpak install org.gtk.Gtk3theme.Numix
