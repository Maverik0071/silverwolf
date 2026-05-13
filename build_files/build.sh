#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux alacritty brave-origin-nightly distrobox dmenu dunst fastfetch flameshot fzf gh git grim grimshot  jetbrains-mono-fonts-all jgmenu jgmenu-gtktheme jgmenu-pmenu lm_sensors lsd mako neovim NetworkManager-tui picom quickshell rofi swww vim waypaper xkill zsh

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
dnf5 -y copr enable lionheartp/Hyprland
dnf5 -y install awww
dnf5 -y install hyprland-guiutils
dnf5 -y install hyprland-protocols
dnf5 -y install hyprpaper 
dnf5 -y install nwg-look
dnf5 disable lionheartp/Hyprland

dnf5 -y copr enable avengemedia/danklinux
dnf5 -y install dms
dnf5 -y install dms-greeter
dnf5 -y install dms dms-greeter
dnf5 -y install quickshell
dnf5 copr disable avengemedia/danklinux

dnf5 copr enable heus-sueh/hyprland
dnf5 -y install swww
dnf5 -y install matugen
dnf5 copr disable heus-sueh/hyprland

dnf5 copr enable solopasha/hyprland
dnf5 -y install hyprland
dnf5 -y install hyprpolkit
dnf5 -y install hyprland
dnf5 -y install swaylock-effects
dnf5 -y install xdg-portal-desktop-hyprland
dnf5 copr disable solopasha/hyprland

#### Example for enabling a System Unit File

systemctl enable podman.socket
