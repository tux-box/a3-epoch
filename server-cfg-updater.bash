#!/bin/bash
set -euo pipefail
REQUIRED_VARS=(
  HOSTNAME
  PASSWORD
  ADMIN_PASSWORD
  COMMAND_PASSWORD
)
for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var-}" ]; then
    echo "Error: $var not set" >&2
    exit 1
  fi
done

if [ $# -ne 1 ]; then
  echo "Usage: $0 <config-file>" >&2
  exit 1
fi

config_file="$1"
sed -e "s/hostname[ \t]=[ \t]"[^"]"/hostname="$HOSTNAME"/g" \
    -e "s/password[ \t]=[ \t]"[^"]"/password="$PASSWORD"/g" \
    -e "s/passwordAdmin[ \t]=[ \t]"[^"]"/passwordAdmin="$ADMIN_PASSWORD"/g" \
    -e "s/serverCommandPassword[ \t]=[ \t]"[^"]"/serverCommandPassword="$COMMAND_PASSWORD"/g" \
    "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"