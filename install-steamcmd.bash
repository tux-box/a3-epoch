# Insert Steam prompt answers
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]
echo steam steam/question select "I AGREE" | debconf-set-selections && echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
dpkg --add-architecture i386 \
    && apt-get update --quiet --quiet \
    && apt-get install --yes --no-install-recommends ca-certificates locales steamcmd \
    && rm --recursive --force /var/lib/apt/lists/*

# Add unicode support
locale-gen en_US.UTF-8
LANG='en_US.UTF-8'
LANGUAGE='en_US:en'

# Create symlink for executable
ln --symbolic /usr/games/steamcmd /usr/bin/steamcmd

# Fix missing directories and libraries
mkdir --parents "$HOME/.steam" \
    && ln --symbolic "$HOME/.local/share/Steam/steamcmd/linux32" "$HOME/.steam/sdk32" \
    && ln --symbolic "$HOME/.local/share/Steam/steamcmd/linux64" "$HOME/.steam/sdk64" \
    && ln --symbolic "$HOME/.steam/sdk32/steamclient.so" "$HOME/.steam/sdk32/steamservice.so" \
    && ln --symbolic "$HOME/.steam/sdk64/steamclient.so" "$HOME/.steam/sdk64/steamservice.so"

# Update SteamCMD and verify latest version
steamcmd +quit