# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --quiet --quiet \
    && apt-get install --yes --no-install-recommends git curl redis-server\
    && rm --recursive --force /var/lib/apt/lists/*