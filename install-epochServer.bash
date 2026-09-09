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