#!/bin/bash

set -ouex pipefail

FEDORA_VERSION=$(rpm -E %fedora)

## Enable repos
dnf5 -y install dnf5-plugins
dnf5 -y copr enable tohur/RakuOS fedora-${FEDORA_VERSION}-x86_64
dnf5 -y copr enable bieszczaders/kernel-cachyos fedora-${FEDORA_VERSION}-x86_64
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons fedora-${FEDORA_VERSION}-x86_64
dnf5 -y copr enable faugus/faugus-launcher fedora-${FEDORA_VERSION}-x86_64
dnf5 -y copr enable ilyaz/LACT fedora-${FEDORA_VERSION}-x86_64
dnf5 -y copr enable garecrow/ExtensionManager fedora-${FEDORA_VERSION}-x86_64
dnf5 -y copr enable wehagy/protonplus fedora-${FEDORA_VERSION}-x86_64
dnf5 -y install \
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm

dnf5 -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-nvidia.repo
rpm --import https://repos.fyralabs.com/terra${FEDORA_VERSION}/key.asc
rpm --import https://repos.fyralabs.com/terra${FEDORA_VERSION}-mesa/key.asc
rpm --import https://repos.fyralabs.com/terra${FEDORA_VERSION}-multimedia/key.asc
#rpm --import https://repos.fyralabs.com/terra${FEDORA_VERSION}-nvidia/key.asc
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf5 -y install --nogpgcheck --repofrompath 'terra-mesa,https://repos.fyralabs.com/terra$releasever' terra-release-mesa
dnf5 -y install --nogpgcheck --repofrompath 'terra-multimedia,https://repos.fyralabs.com/terra$releasever' terra-release-multimedia
#dnf5 -y install --nogpgcheck --repofrompath 'terra-nvidia,https://repos.fyralabs.com/terra$releasever' terra-release-nvidia
# Remove hardcoded priority=80 from terra repo files so our config-manager priorities take effect
sed -i '/^priority=/d' /etc/yum.repos.d/terra*.repo


# Download Terra AppStream data for rakuos-software
TERRA_BASE="https://repos.fyralabs.com/appstream"
TERRA_REPOS="terra${FEDORA_VERSION} terra${FEDORA_VERSION}-mesa terra${FEDORA_VERSION}-nvidia terra${FEDORA_VERSION}-extras terra${FEDORA_VERSION}-multimedia"
mkdir -p /usr/share/swcatalog/xml
for REPO in $TERRA_REPOS; do
    BASE_URL="${TERRA_BASE}/${REPO}/latest/appstream"
    # AppStream XML
    curl -fsSL "${BASE_URL}/${REPO}.xml.gz" -o "/usr/share/swcatalog/xml/${REPO}.xml.gz" \
        && echo "Terra AppStream: ${REPO}.xml.gz" || echo "Warning: failed to download AppStream for ${REPO}"
    # Icons — 64x64 and 128x128
    mkdir -p "/usr/share/swcatalog/icons/${REPO}/64x64"
    mkdir -p "/usr/share/swcatalog/icons/${REPO}/128x128"
    curl -fsSL "${BASE_URL}/${REPO}-icons-64x64.tar.gz" \
        | tar -xz -C "/usr/share/swcatalog/icons/${REPO}/64x64" --strip-components=1 2>/dev/null || true
    curl -fsSL "${BASE_URL}/${REPO}-icons-128x128.tar.gz" \
        | tar -xz -C "/usr/share/swcatalog/icons/${REPO}/128x128" --strip-components=1 2>/dev/null || true
done

## Install packages
dnf5.real -y install @fonts @hardware-support \
  # install packages
dnf5 -y install ananicy-cpp \
cachyos-ananicy-rules \
cachyos-settings \
bore-sysctl \
scx-scheds \
scx-tools \
gamemode \
pulseaudio-utils \
dkms \
akmods \
kernel-cachyos-devel-${QUALIFIED_KERNEL} \
elfutils-libelf-devel \
openssl-devel \
git \
flatpak \
libxcrypt-compat \
rsync \
podman \
distrobox \
mokutil \
lm_sensors \
sqlite3 \
openssl \
libnotify \
inotify-tools \
podman-compose \
python3-pip \
python3-setuptools \
appstream \
appstream-data \
fwupd \
fuse \
squashfuse \
virtualbox-guest-additions \
v4l-utils \
unzip \
gdm \
gnome-session \
gnome-shell \
gnome-settings-daemon \
gnome-backgrounds \
gnome-control-center \
NetworkManager-bluetooth \
pipewire \
wireplumber \
dnf5 install -y tmux \
dnf5 install -y alacritty \
dnf5 install -y distrobox \
dnf5 install -y dmenu \
dnf5 install -y dunst \
dnf5 install -y fastfetch \
dnf5 install -y flameshot \
dnf5 install -y fzf \
dnf5 install -y gh \
dnf5 install -y git \
dnf5 install -y grim \
dnf5 install -y grimshot \
dnf5 install -y jetbrains-mono-fonts-all \
dnf5 install -y jgmenu \
dnf5 install -y jgmenu-gtktheme \
dnf5 install -y jgmenu-menu \
dnf5 install -y lm_sensors \
dnf5 install -y lsd \
dnf5 install -y neovim \
dnf5 install -y NetworkManager-tui \
dnf5 install -y picom \
dnf5 install -y quickshell \
dnf5 install -y rofi \
xdg-desktop-portal-gnome \
gnome-shell-extension-appindicator \
gnome-shell-extension-no-overview \
gnome-shell-extension-dash-to-dock \
gnome-shell-extension-blur-my-shell \
rakuos-welcome-gtk \
rakuos-software-gtk \
#dnf5 install -y swww
dnf5 install -y vim \
#dnf5 install -y waypaper
dnf5 install -y xkill \
dnf5 install -y zsh \

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


  # Install cachyos kernel
dnf5 -y --setopt=tsflags=noscripts install kernel-cachyos kernel-cachyos-devel-matched

dnf5 -y swap ffmpeg ffmpeg-free --allowerasing

dnf5 -y install mesa-dri-drivers.i686 mesa-va-drivers.i686 mesa-vulkan-drivers.i686 mesa-libEGL.i686 mesa-libGL.i686
dnf5 -y upgrade --best 'mesa-*'

# Determine the installed kernel version
QUALIFIED_KERNEL=$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel-cachyos)

## Remove packages
dnf5.real -y remove gnome-software-rpm-ostree gnome-tour

## Compile GSettings schemas (picks up zz-rakuos-gnome.gschema.override)
glib-compile-schemas /usr/share/glib-2.0/schemas/

## Enable Services
systemctl enable gdm.service
