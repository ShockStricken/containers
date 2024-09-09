#!/usr/bin/env bash

#shellcheck disable=SC1091
test -f "/scripts/umask.sh" && source "/scripts/umask.sh"

export LD_LIBRARY_PATH="/app/emby"
export FONTCONFIG_PATH="/app/emby/etc/fonts"
if [ -d "/lib/x86_64-linux-gnu" ]; then
	export LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri:/app/emby/dri"
fi
export SSL_CERT_FILE="/app/emby/etc/ssl/certs/ca-certificates.crt"

#shellcheck disable=SC2086
exec \
	/app/emby/bin/EmbyServer \
		-programdata /config \
		-ffdetect /app/emby/bin/ffdetect \
		-ffmpeg /app/emby/bin/ffmpeg \
		-ffprobe /app/emby/bin/ffprobe \
		-restartexitcode 3 \
        "$@"
