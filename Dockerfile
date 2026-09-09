######## INSTALL ########

# Set the base image
FROM ubuntu:26.04

# Set environment variables
ENV USER=root
ENV HOME=/root

#set install features to noninteractive.
ARG DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR $HOME

RUN mkdir -p /root/epoch-packages
RUN mkdir -p /epoch


RUN apt-get update --quiet --quiet && apt-get install --yes --no-install-recommends git curl && rm --recursive --force /var/lib/apt/lists/*

#install Steamcmd
RUN curl -sL https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/install-steamcmd.bash | bash

#install addional softwares
RUN curl -sL https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/install-softwares.bash | bash

#configure redis
RUN curl -sL https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/configure-redis.bash | bash

#download epoch server
RUN curl -sL https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/install-epochServer.bash | bash

#configure epoch server
RUN curl -sL https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/configure-epochServer.bash | bash

#copy run script to location
RUN curl https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/run-Epoch.bash > /epoch/run-Epoch.bash

#requires Steam Logins
CMD curl -sL https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/post-build-work.bash | bash

#RUN curl -o run-Epoch.bash https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/run-Epoch.bash

#CMD ["/epoch/run-Epoch.bash"]
# Set default command
ENTRYPOINT ["/epoch/run-Epoch.bash"]
#ENTRYPOINT ["steamcmd"]
#CMD ["+help", "+quit"]