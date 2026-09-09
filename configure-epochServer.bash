#Let's configure things.
#update config's with enviroument varables. 
REQUIRED_VARS=(
    HOSTNAME
    ADMIN_PASSWORD
    COMMAND_PASSWORD
)
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var-}" ]; then
        echo "Error: $var not set" >&2
        exit 1
    fi
done

## todo, update $1 to the actual file.
config_file="/epoch/sc/server.cfg"
sed -e "s/hostname[ \t]=[ \t]"[^"]"/hostname="$HOSTNAME"/g" -e "s/password[ \t]=[ \t]"[^"]"/password="$PASSWORD"/g" -e "s/passwordAdmin[ \t]=[ \t]"[^"]"/passwordAdmin="$ADMIN_PASSWORD"/g" -e "s/serverCommandPassword[ \t]=[ \t]"[^"]"/serverCommandPassword="$COMMAND_PASSWORD"/g" "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
