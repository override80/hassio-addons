#!/bin/sh
set -e

##########################################
# Global modifications before entrypoint #
##########################################

# Corrects permissions for s6 v3
################################

PUID="${PUID:-0}"
PGID="${PGID:-0}"

if [ -f /ha_entrypoint.sh ]; then
    chown -R "$PUID:$PGID" /ha_entrypoint.sh
    chmod -R 755 /ha_entrypoint.sh
fi

if [ -d /etc/cont-init.d ]; then
    chown -R "$PUID:$PGID" /etc/cont-init.d
    chmod -R 755 /etc/cont-init.d
fi

if [ -d /etc/services.d ]; then
    chown -R "$PUID:$PGID" /etc/services.d
    chmod -R 755 /etc/services.d
fi

if [ -d /etc/s6-rc.d ]; then
    chown -R "$PUID:$PGID" /etc/s6-rc.d
    chmod -R 755 /etc/s6-rc.d
fi

# Correct shebang in entrypoint
###############################

# Make s6 contenv if needed
mkdir -p /run/s6/container_environment

# Check if shebang exists
for shebang in "/command/with-contenv bashio" "/usr/bin/env bashio" "/usr/bin/bashio" "/bin/bash" "/bin/sh"; do
    if [ -f "${shebang%% *}" ]; then
        break
    fi
done

# Define shebang
sed -i "s|/command/with-contenv bashio|$shebang|g" /ha_entrypoint.sh
