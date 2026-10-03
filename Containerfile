ARG FEDORA_VERSION="${FEDORA_VERSION:-43}"
ENV FEDORA_VERSION=${FEDORA_VERSION}
ARG BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-latest}"
ENV BASE_IMAGE_TAG=${BASE_IMAGE_TAG}
# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/rakuos/rakuos-base:${BASE_IMAGE_TAG}
COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && /ctx/post-build.sh && /ctx/post-build-overlay.sh
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
