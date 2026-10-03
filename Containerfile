# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
# FROM ghcr.io/maverik0071/silverwolf:latest

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
FROM ghcr.io/rakuos/rakuos-hyprland:lateest
# Or your specific desired starting base tag


# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### [IM]MUTABLE /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lintos-release identity instead of the stable one, so
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
