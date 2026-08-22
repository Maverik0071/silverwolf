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
#dnf5 install -y grim
#dnf5 install -y grimshot
dnf5 install -y jetbrains-mono-fonts-all
dnf5 install -y jgmenu
dnf5 install -y jgmenu-gtktheme
dnf5 install -y jgmenu-pmenu
dnf5 install -y lm_sensors
dnf5 install -y lsd 
dnf5 install -y mako
dnf5 install -y neovim
dnf5 install -y NetworkManager-tui
dnf5 install -y picom
dnf5 install -y quickshell
dnf5 install -y rofi
dnf5 install -y greetd
#dnf5 install -y docker
dnf5 install -y cockpit
#dnf5 install -y swww
dnf5 install -y vim
dnf5 install -y neovim
dnf5 install -y zoxide
#dnf5 install -y waypaper
dnf5 install -y xkill
dnf5 install -y zsh
dnf5 install -y nmap
dnf5 install -y wireshark

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
#curl -fsSL https://raw.githubusercontent.com/terrapkg/packages/f$(rpm --eval '%{fedora}')/anda/terra/release/terra.repo | pkexec tee /etc/yum.repos.d/terra.repo
#rpm-ostree install terra-release terra-gpg-keys

dnf5 -y copr enable lionheartp/Hyprland
dnf5 -y install awww
dnf5 -y install hyprland
dnf5 -y install hyprland-guiutils
# dnf5 -y install hyprland-protocols
#dnf5 -y install hyprpaper
dnf5 -y install nwg-look
#dnf5 -y copr disable lionheartp/Hyprland

# dnf5 -y copr enable avengemedia/danklinux
#dnf5 -y install dms
#dnf5 -y install dms-greeter
#dnf5 -y install dms dms-greeter
dnf5 -y install quickshell
#dnf5 -y copr disable avengemedia/danklinux

#dnf5 copr enable heus-sueh/hyprland
#dnf5 -y install swww
#dnf5 -y install matugen
#dnf5 -y copr disable heus-sueh/hyprland

#dnf5 copr enable solopasha/hyprland
#dnf5 -y install hyprland
#dnf5 -y install hyprpolkit
#dnf5 -y install swaylock-effects
#dnf5 -y install xdg-portal-desktop-hyprland
#dnf5 -y copr disable solopasha/hyprland

#### Example for enabling a System Unit File
systemctl enable podman.socket
# systemctl enable greetd
systemctl enable cockpit
