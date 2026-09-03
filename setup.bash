#!/bin/bash
#setup Redis?
#we should force the redis config to match our needs.
#backup the existing redis config 
cp /etc/redis/redis.conf /etc/redis/redis.conf.org
#Replace the information in the redis file with our own information.
echo "Your content here" > /etc/redis/redis.conf
echo "bind 127.0.0.1" >> /etc/redis/redis.conf
echo "port 6379" >> /etc/redis/redis.conf
echo "maxmemory 1gb" >> /etc/redis/redis.conf
echo "save 900 1" >> /etc/redis/redis.conf
echo "save 300 10" >> /etc/redis/redis.conf
echo "save 60 1000" >> /etc/redis/redis.conf
echo "requirepass RedisPass1" >> /etc/redis/redis.conf


#create a directory to work out of. The intent is to run this from the existing steamcmd latest docker container. 
mkdir /root/epoch-packages

#create a directory for the actual server files.
mkdir /epoch

#cd /root/epoch-packages

#clone the current github available 
git clone https://github.com/tux-box/Epoch.git /root/epoch-packages

#Make all the files and folders lowercase for linux capatablity.
find . -depth -exec bash -c 'f="$1"; p=$(dirname "$f"); n=$(basename "$f" | tr "A-Z" "a-z"); if [ ! -e "$p/$n" ]; then mv "$f" "$p/$n"; fi' _ {} \;

#