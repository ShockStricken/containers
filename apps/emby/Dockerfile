FROM docker.io/library/ubuntu:24.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive" \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="DontWarn"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /tmp

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jo \
        jq \
        nano \
        tzdata \
        uuid-runtime \
        xmlstarlet \
    && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export ARCH='amd64'; \
        ;; \
        'linux/arm64') \
            export ARCH='arm64'; \
        ;; \
    esac \
    && \
    curl -fsSL -o emby.rpm \
        "https://github.com/MediaBrowser/Emby.Releases/releases/download/${VERSION}/emby-server-rpm_${VERSION}_${ARCH}.rpm" \
    && \
    rpm2cpio emby.rpm | cpio -i --make-directories \
    && \
    mv -t \
        /app/emby \
        /tmp/opt/emby-server/system/* \
        /tmp/opt/emby-server/lib/* \
        /tmp/opt/emby-server/bin/ff* \
        /tmp/opt/emby-server/etc \
        /tmp/opt/emby-server/extra/lib/* \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean


COPY ./apps/emby/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT [ "/usr/bin/catatonit", "--" ]
CMD ["/entrypoint.sh"]
