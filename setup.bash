#!/bin/bash
set -euo pipefail  

RedisSetup(){
    #setup Redis
    #we should force the redis config to match our needs.
    #backup the existing redis config 
    cp /etc/redis/redis.conf /etc/redis/redis.conf.org

    #Replace the information in the redis file with our own information.
    curl "https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/redis.conf" > /etc/redis/redis.conf

}

EpochServerDownloader(){
    #is there a steam package for this?

    #create a directory to work out of. The intent is to run this from the existing steamcmd latest docker container. 
    mkdir /root/epoch-packages

    #create a directory for the actual server files.
    if [[ ! -d "/epoch" ]]; then
        mkdir -p /epoch
        echo "Directory created"
    else
        echo "Directory already exists"
    fi
    

    #cd /root/epoch-packages

    #clone the current github available 
    git clone https://github.com/tux-box/Epoch.git /root/epoch-packages

    #Make all the files and folders lowercase for linux capatablity.
    #find /root/epoch-packages -depth -exec bash -c 'f="$1"; p=$(dirname "$f"); n=$(basename "$f" | tr "A-Z" "a-z"); if [ ! -e "$p/$n" ]; then mv "$f" "$p/$n"; fi' _ {} \;

    find /root/epoch-packages -depth -exec bash -c '
        for path; do
            lower=$(dirname "$path")/$(basename "$path" | tr "[:upper:]" "[:lower:]")
            if [[ "$path" != "$lower" ]]; then
                mv "$path" "$lower"
            fi
        done
    ' bash {} +


    #copy all the files to the correct place.
    cp -r -f /root/epoch-packages/server_install_pack/sc /epoch/sc
    cp -r -f /root/epoch-packages/server_install_pack/mpmissions /epoch/mpmissions
    cp -r -f /root/epoch-packages/server_install_pack/@epochhive /epoch/@epochhive

    #Download My conigs for ease of editiing.
    curl https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/server.cfg > /epoch/sc/server.cfg
    curl https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/basic.cfg > /epoch/sc/basic.cfg
    curl https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/beserver.cfg > /epoch/sc/battleye/beserver.cfg
    curl https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/beserver_x64.cfg > /epoch/sc/battleye/beserver_x64.cfg
}

config-updater(){
    #Let's configure things.
    #update config's with enviroument varables. 
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

    ## todo, update $1 to the actual file.
    config_file="$1"
    sed -e "s/hostname[ \t]=[ \t]"[^"]"/hostname="$HOSTNAME"/g" -e "s/password[ \t]=[ \t]"[^"]"/password="$PASSWORD"/g" -e "s/passwordAdmin[ \t]=[ \t]"[^"]"/passwordAdmin="$ADMIN_PASSWORD"/g" -e "s/serverCommandPassword[ \t]=[ \t]"[^"]"/serverCommandPassword="$COMMAND_PASSWORD"/g" "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
}

arma3Install(){
    #steam install arma3 full, dedcated server?
    case "$1" in
        full) echo "Installing full ARMA 3: "steamcmd +login $SteamLogin -dir /epoch +app_install 107410 +quit;;
        dedicated) echo "Installing dedicated server: " steamcmd +login $SteamLogin -dir /epoch +app_install 107410 +quit;;
        *) echo "Usage: install_arma [full|dedicated]"; exit 1;;
    esac
}

workShopModInstaller(){
    #import a list of mods to install
    for mods in "${mods[@]}"; do
        steamcmd +login $SteamLogin -dir /epoch +workshop_download_item 107410 $mod
    done
}


#to do..
    #redis setup
    RedisSetup

    #download epoch server install pack
    EpochServerDownloader

    #update the server config with our enviroument varables, continued. Specfiy the full file name with path.
    config-updater "/epoch/sc/server.cfg"

    #steam install arma3, full or dedicated server to /epoch
    arma3Install dedicated

    #steam install epoch mod from seam workshop
    mods=("apple" "banana" "cherry") #enter the workshop id's here.
    workShopModInstaller 421839251

    #copy file to the correct directory.