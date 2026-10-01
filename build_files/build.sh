#!/bin/bash

set -ouex pipefail

FEDORA_VERSION=$(rpm -E %fedora)

## Install packages
dnf5.real -y install @fonts @hardware-support \
  gdm \
  gnome-session \
  gnome-shell \
  gnome-settings-daemon \
  gnome-backgrounds \
  gnome-control-center \
  NetworkManager-bluetooth \
  pipewire \
  wireplumber \
  xdg-desktop-portal-gnome \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-no-overview \
  gnome-shell-extension-dash-to-dock \
  gnome-shell-extension-blur-my-shell \
  rakuos-welcome-gtk \
  rakuos-software-gtk

## Remove packages
dnf5.real -y remove gnome-software-rpm-ostree gnome-tour

## Compile GSettings schemas (picks up zz-rakuos-gnome.gschema.override)
glib-compile-schemas /usr/share/glib-2.0/schemas/

## Enable Services
systemctl enable gdm.service
