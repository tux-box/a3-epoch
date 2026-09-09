RedisSetup(){
    #setup Redis
    #we should force the redis config to match our needs.
    #backup the existing redis config 
    cp /etc/redis/redis.conf /etc/redis/redis.conf.org

    #Replace the information in the redis file with our own information.
    curl "https://raw.githubusercontent.com/tux-box/a3-epoch/refs/heads/main/redis.conf" > /etc/redis/redis.conf

}