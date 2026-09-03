#!/bin/bash

#create a directory to work out of. The intent is to run this from the existing steamcmd latest docker container. 
mkdir /root/epoch-packages

#create a directory for the actual server files.
mkdir /epoch

#cd /root/epoch-packages

#clone the current github available 
git clone https://github.com/tux-box/Epoch.git /root/epoch-packages

#Make all the files and folders lowercase for linux capatablity.
find . -depth -exec bash -c 'f="$1"; p=$(dirname "$f"); n=$(basename "$f" | tr "A-Z" "a-z"); if [ ! -e "$p/$n" ]; then mv "$f" "$p/$n"; fi' _ {} \;

#Let's configure things.

#setup Redis
#we should force the redis config to match our needs.
#backup the existing redis config 
cp /etc/redis/redis.conf /etc/redis/redis.conf.org

#Replace the information in the redis file with our own information.
echo "https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/redis.conf" > /etc/redis/redis.conf

