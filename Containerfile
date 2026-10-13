# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
#FROM ghcr.io/wayblueorg/hyprland:latest
# FROM ghcr.io/rakuos/rakuos-base:latest
FROM quay.io/rakuos/rakuos-niri:latest

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
#FROM ghcr.io/rakuos/rakuos-gnome:latest
# FROM ghcr.io/rakuos/rakuos-base:latest
#FROM ghcr.io/wayblueorg/hyprland:latest
#FROM ghcr.io/wayblueorg/hyprland:44
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

#RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=cache,dst=/var/cache \
#    --mount=type=cache,dst=/var/log \
#    --mount=type=tmpfs,dst=/tmp \
#     /ctx/build.sh

### LINTING
## Verify final image and contents are correct.
#RUN bootc container lint

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && /ctx/post-build.sh && /ctx/post-build-overlay.sh

COPY system_files /

# Clean up real runtime state (systemd units started mid-build, akmods/
# cryptsetup/etc. lock and socket files) that only ever makes sense on a
# live booted system, before the lint step inspects the committed image.
# This runs as its own RUN, after every mounted (--mount=type=secret/
# cache/tmpfs) build step above has already finished and unmounted, so it
# only ever touches plain files already baked into the layer — never a
# live mount the build engine itself still has open.
RUN find /run -mindepth 1 -delete 2>/dev/null || true; \
    find /tmp -mindepth 1 -delete 2>/dev/null || true; \
    find /boot -mindepth 1 -delete 2>/dev/null || true

# RUN bootc container lint

FROM quay.io/coreos/chunkah AS chunkah
ARG CHUNKAH_CONFIG_STR
RUN --mount=from=builder,src=/,target=/chunkah,ro \
    --mount=type=bind,target=/run/src,rw \
        chunkah build --prune /sysroot/ --max-layers 128 --compressed --threads 4 \
          --label ostree.commit- --label ostree.final-diffid- \
          > /run/src/out.ociarchive

FROM oci-archive:out.ociarchive
LABEL containers.bootc=1
