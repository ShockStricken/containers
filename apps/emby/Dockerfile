FROM docker.io/library/ubuntu:24.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive"

ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /tmp

# hadolint ignore=DL3008,DL3015,SC2039,SC2086
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            export ARCH='amd64'; \
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
        ;; \
        'linux/arm64') \
            export ARCH='arm64'; \
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
                libomxil-bellagio0 \
                libomxil-bellagio-bin \
                libraspberrypi0 \
        ;; \
    esac && \
    curl -fsSL -o /tmp/emby.deb \
        "https://github.com/MediaBrowser/Emby.Releases/releases/download/${VERSION}/emby-server-deb_${VERSION}_${ARCH}.deb" && \
    echo "**** install emby ****" && \
    mkdir -p \
      /app/emby \
      /tmp/emby && \
    dpkg-deb -xv /tmp/emby.deb /tmp/emby/ && \
    mv -t \
      /app/emby/ \
      /tmp/opt/emby/emby-server/* && \

    echo "**** cleanup ****" && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

COPY ./apps/emby/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT [ "/usr/bin/catatonit", "--" ]
CMD ["/entrypoint.sh"]
