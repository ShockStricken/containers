ARG VERSION
FROM docker.io/library/python:3.12.6-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV \
    COMPlus_EnableDiagnostics="0" \
    LIDARR__UPDATE__BRANCH="${CHANNEL}" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1

ENV UMASK="0002" \
    TZ="Etc/UTC"

USER root
WORKDIR /app

#hadolint ignore=DL3018,DL3059
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        chromaprint \
        coreutils \
        curl \
        ffmpeg \
        icu-libs \
        jo \
        jq \
        libintl \
        nano \
        sqlite-libs \
        trurl \
        tzdata \
        tidyhtml \
        musl-locales \
        musl-locales-lang \
        flac \
        gcc \
        imagemagick \
        opus-tools \
        opustags \
        python3-dev \
        libc-dev \
        py3-pip \
        npm \
    && \
    echo "*** install freyr client ***" && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing atomicparsley && \
    npm install -g miraclx/freyr-js \
    && \
    echo "*** install python packages ***" && \
    pip install \
        jellyfish \
        beautifulsoup4 \
        yt-dlp \
        beets \
        yq \
        pyxDamerauLevenshtein \
        pyacoustid \
        requests \
        colorama \
        pylast \
        mutagen \
        r128gain \
        tidal-dl \
        deemix && \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x64' ;; \
        'linux/arm64') export ARCH='arm64' ;; \
    esac \
    && \
    mkdir -p /app/bin \
    && \
    curl -fsSL "https://lidarr.servarr.com/v1/update/${LIDARR__UPDATE__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${ARCH}" \
        | tar xzf - -C /app/bin --strip-components=1 \
    && \
    rm -rf /app/bin/Lidarr.Update /app/bin/fpcalc \
    && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[ShockStruck](https://github.com/shockstruck)\n" "${LIDARR__UPDATE__BRANCH}" "${VERSION}" > /app/package_info \
    && chown -R root:root /app \
    && chmod -R 755 /app \
    && apk del npm \
    && rm -rf /tmp/*

COPY ./apps/lidarr/entrypoint.sh /entrypoint.sh

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/Lidarr/Lidarr"
