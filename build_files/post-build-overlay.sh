#!/usr/bin/env bash
# post-build-overlay.sh
# Runs inside the container build (Containerfile RUN step / GitHub Actions).
#
# Does NOT install packages — that's impossible inside a container build
# because overlayfs on /usr requires CAP_SYS_ADMIN and a real kernel mount.
#
# Instead, this script seeds /var/lib/rakuos/ into a "post-reset" state:
#   - packages.list populated from /usr/share/rakuos/packages.list
#   - overlay upper/work dirs created and empty
#   - overlay.state intentionally absent
#
# On first boot, rakuos-overlay-sync.service sees the missing state file,
# treats it as a fresh/reset system, and performs a full install into the
# overlay automatically — no user interaction needed.
#
# Usage (from your Containerfile):
#   RUN /usr/libexec/rakuos/build/post-build-overlay.sh

set -euo pipefail

DEFAULT_PACKAGES_LIST="/usr/share/rakuos/packages.list"
PACKAGES_LIST="/var/lib/rakuos/packages.list"
UPPER_DIR="/var/lib/rakuos/overlay/upper"
WORK_DIR="/var/lib/rakuos/overlay/work"
STATE_FILE="/var/lib/rakuos/overlay.state"
DIRTY_FILE="/var/lib/rakuos/overlay.dirty"

echo "[rakuos] Seeding overlay state for first-boot install..."

# ── Create runtime dirs ───────────────────────────────────────────────────────

mkdir -p /var/lib/rakuos
mkdir -p "$UPPER_DIR"
mkdir -p "$WORK_DIR"

# ── Seed packages.list ────────────────────────────────────────────────────────

if [[ -f "$DEFAULT_PACKAGES_LIST" ]]; then
    cp "$DEFAULT_PACKAGES_LIST" "$PACKAGES_LIST"
    PKG_COUNT=$(grep -v '^\s*#' "$PACKAGES_LIST" | grep -v '^\s*$' | wc -l)
    echo "[rakuos] packages.list seeded with $PKG_COUNT packages."
else
    echo "[rakuos] WARNING: No default packages.list at $DEFAULT_PACKAGES_LIST"
    echo "[rakuos] Creating empty packages.list — no packages will be installed on first boot."
    touch "$PACKAGES_LIST"
fi

# ── Ensure state is absent (triggers full install on first boot) ──────────────
# overlay-sync treats a missing STATE_FILE as "fresh/reset" and performs
# a full install of everything in packages.list.

rm -f "$STATE_FILE"
rm -f "$DIRTY_FILE"

# Ensure packages.list ends with newline
sed -i -e '$a\' /var/lib/rakuos/packages.list

echo "[rakuos] overlay.state cleared — first boot will install all packages."
echo "[rakuos] Post-build seed complete."

echo "Appending GNOME protected packages to protected-packages.txt..."
cat >> /usr/share/rakuos/protected-packages.txt << 'EOF'

# GNOME DE packages (from rakuos-gnome/build_files/build.sh)
gdm
gnome-session
gnome-shell
gnome-settings-daemon
gnome-backgrounds
gnome-control-center
NetworkManager-bluetooth
pipewire
wireplumber
xdg-desktop-portal-gnome
gnome-shell-extension-appindicator
rakuos-welcome-gtk
rakuos-software-gtk
EOF

echo "Generating base file manifest..."
/usr/libexec/rakuos/generate-base-manifest
