#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux
dnf5 install -y alacritty
# dnf5 install -y brave-origin-nightly
dnf5 install -y distrobox
dnf5 install -y dmenu
dnf5 install -y dunst
dnf5 install -y fastfetch
dnf5 install -y flameshot
dnf5 install -y fzf
dnf5 install -y gh
dnf5 install -y git
dnf5 install -y grim
dnf5 install -y grimshot
dnf5 install -y jetbrains-mono-fonts-all
dnf5 install -y jgmenu
dnf5 install -y jgmenu-gtktheme
dnf5 install -y jgmenu-pmenu
dnf5 install -y lm_sensors
dnf5 install -y lsd mako
dnf5 install -y neovim
dnf5 install -y NetworkManager-tui
dnf5 install -y picom
dnf5 install -y quickshell
dnf5 install -y rofi
#dnf5 install -y swww
dnf5 install -y vim
#dnf5 install -y waypaper
dnf5 install -y xkill
dnf5 install -y zsh

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
dnf5 -y copr enable lionheartp/Hyprland
dnf5 -y install awww
dnf5 -y install hyprland
dnf5 -y install hyprland-guiutils
# dnf5 -y install hyprland-protocols
dnf5 -y install hyprpaper
dnf5 -y install nwg-look
dnf5 -y copr disable lionheartp/Hyprland

dnf5 -y copr enable avengemedia/danklinux
dnf5 -y install dms
dnf5 -y install dms-greeter
dnf5 -y install dms dms-greeter
dnf5 -y install quickshell
dnf5 -y copr disable avengemedia/danklinux

#dnf5 copr enable heus-sueh/hyprland
#dnf5 -y install swww
#dnf5 -y install matugen
#dnf5 -y copr disable heus-sueh/hyprland

#dnf5 copr enable solopasha/hyprland
#dnf5 -y install hyprland
#dnf5 -y install hyprpolkit
#dnf5 -y install hyprland
#dnf5 -y install swaylock-effects
#dnf5 -y install xdg-portal-desktop-hyprland
#dnf5 -y copr disable solopasha/hyprland

#### Example for enabling a System Unit File

systemctl enable podman.socketrpm -E %fedora)

# On the staging branch (RAKUOS_STAGING=1, set via --build-arg from CI)
# install the staging os-release identity instead of the stable one, so
# staging images identify themselves as "RakuOS NIRI Staging".
RAKUOS_RELEASE_PKG="rakuos-release-niri"
if [ "${RAKUOS_STAGING:-0}" = "1" ]; then
    RAKUOS_RELEASE_PKG="rakuos-release-niri-staging"
fi

# Terra ships disabled by default (third-party repos are opt-in), so enable
# it here in case any packages below come from Terra; post-build.sh disables
# it again before the image is finalized.
rum config-manager --set-enabled terra

## Install packages
# FIXME: Remove quickshell-git when Fedora gets 0.3 version
# ghostty-kio satisfies ghostty's rich Requires (`ghostty-kio = ... if
# kf6-kio-core`); without it baked in now, any later kf6-kio-core install
# (e.g. kde-partitionmanager) fails once Terra is disabled below.
rum install -y \
  niri \
  dms \
  dankcalendar-git \
  danksearch \
  dgop \
  dms-greeter \
  nm-connection-editor \
  pavucontrol \
  ddcutil \
  adw-gtk3-theme \
  file-roller \
  fprintd-pam \
  gnome-calculator \
  gnome-disk-utility \
  gvfs-nfs \
  ibus-mozc \
  ibus-unikey \
  nautilus \
  cups-pk-helper \
  tuned \
  tuned-ppd \
  gvfs \
  gvfs-mtp \
  cava \
  wl-clipboard \
  matugen \
  quickshell-git \
  wtype \
  qt6ct-kde \
  wl-mirror \
  libnotify \
  blueman \
  gnome-keyring \
  gnome-keyring-pam \
  xwayland-satellite-0:0.8.1-1.fc44 \
  NetworkManager-adsl \
  NetworkManager-bluetooth \
  NetworkManager-ppp \
  NetworkManager-wwan \
  pipewire \
  pipewire-pulseaudio \
  ghostty \
  ghostty-nautilus \
  ghostty-kio \
  ${RAKUOS_RELEASE_PKG} \
  rakuos-software-gtk \
  rakuos-system-gtk \
  rakuos-welcome-gtk \
  systemd-oomd-defaults \
  wireplumber \
  xdg-desktop-portal \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal-gtk \
  xdg-user-dirs-gtk

rum remove -y waybar swaylock alacritty fuzzel

## Remove fedora wallpapers
#rm -r /usr/share/backgrounds/fedora-workstation/

## Fix default applications
sed -i \
  -e '/text\/plain=org\.gnome\.gedit\.desktop/d' \
  -e '/org\.gnome\.eog\.desktop/d' \
  -e '/org\.gnome\.Totem\.desktop/d' \
  -e '/org\.gnome\.Rhythmbox3\.desktop/d' \
  -e 's|application/pdf=org\.gnome\.Evince\.desktop|application/pdf=org.mozilla.firefox.desktop|g' \
  /usr/share/applications/mimeapps.list

## Unlock keyring on login
sed -i -E 's/^-([a-z]+[[:space:]]+.*pam_gnome_keyring\.so)/\1/' /etc/pam.d/greetd

## Enable Services
systemctl enable greetd
systemctl enable --global dotfiles-setup
systemctl enable --global dsearch dms
ging branch (RAKUOS_STAGING=1, set via --build-arg from CI)
# install the staging os-release identity instead of the stable one, so
# staging images identify themselves as "RakuOS NIRI Staging".
RAKUOS_RELEASE_PKG="rakuos-release-niri"
if [ "${RAKUOS_STAGING:-0}" = "1" ]; then
    RAKUOS_RELEASE_PKG="rakuos-release-niri-staging"
fi

# Terra ships disabled by default (third-party repos are opt-in), so enable
# it here in case any packages below come from Terra; post-build.sh disables
# it again before the image is finalized.
rum config-manager --set-enabled terra

## Install packages
# FIXME: Remove quickshell-git when Fedora gets 0.3 version
# ghostty-kio satisfies ghostty's rich Requires (`ghostty-kio = ... if
# kf6-kio-core`); without it baked in now, any later kf6-kio-core install
# (e.g. kde-partitionmanager) fails once Terra is disabled below.
rum install -y \
  niri \
  dms \
  dankcalendar-git \
  danksearch \
  dgop \
  dms-greeter \
  nm-connection-editor \
  pavucontrol \
  ddcutil \
  adw-gtk3-theme \
  file-roller \
  fprintd-pam \
  gnome-calculator \
  gnome-disk-utility \
  gvfs-nfs \
  ibus-mozc \
  ibus-unikey \
  nautilus \
  cups-pk-helper \
  tuned \
  tuned-ppd \
  gvfs \
  gvfs-mtp \
  cava \
  wl-clipboard \
  matugen \
  quickshell-git \
  wtype \
  qt6ct-kde \
  wl-mirror \
  libnotify \
  blueman \
  gnome-keyring \
  gnome-keyring-pam \
  xwayland-satellite-0:0.8.1-1.fc44 \
  NetworkManager-adsl \
  NetworkManager-bluetooth \
  NetworkManager-ppp \
  NetworkManager-wwan \
  pipewire \
  pipewire-pulseaudio \
  ghostty \
  ghostty-nautilus \
  ghostty-kio \
  ${RAKUOS_RELEASE_PKG} \
  rakuos-software-gtk \
  rakuos-system-gtk \
  rakuos-welcome-gtk \
  systemd-oomd-defaults \
  wireplumber \
  xdg-desktop-portal \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal-gtk \
  xdg-user-dirs-gtk

rum remove -y waybar swaylock alacritty fuzzel

## Remove fedora wallpapers
#rm -r /usr/share/backgrounds/fedora-workstation/

## Fix default applications
sed -i \
  -e '/text\/plain=org\.gnome\.gedit\.desktop/d' \
  -e '/org\.gnome\.eog\.desktop/d' \
  -e '/org\.gnome\.Totem\.desktop/d' \
  -e '/org\.gnome\.Rhythmbox3\.desktop/d' \
  -e 's|application/pdf=org\.gnome\.Evince\.desktop|application/pdf=org.mozilla.firefox.desktop|g' \
  /usr/share/applications/mimeapps.list

## Unlock keyring on login
sed -i -E 's/^-([a-z]+[[:space:]]+.*pam_gnome_keyring\.so)/\1/' /etc/pam.d/greetd

## Enable Services
systemctl enable greetd
systemctl enable --global dotfiles-setup
systemctl enable --global dsearch dms
