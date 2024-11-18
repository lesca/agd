#!/bin/sh
# generate the config files
/app/sakura-sdk-server &
/app/sakura-dispatch-server &
/app/sakura-gate-server &
/app/sakura-game-server &
sleep 5

# replace the ACCESS_IP in the config files
killall sakura-sdk-server sakura-dispatch-server sakura-gate-server sakura-game-server
if [ -n "$ACCESS_IP" ]; then
    echo "ACCESS_IP is set to $ACCESS_IP"
    sed -i 's|127.0.0.1|'$ACCESS_IP'|g' /app/assets/region/region_list.json
    sed -i 's|127.0.0.1|'$ACCESS_IP'|g' /app/*.toml
    sed -i 's|localhost|'$ACCESS_IP'|g' /app/*.toml
else
    echo "ACCESS_IP is not set, using default (127.0.0.1)."
    ACCESS_IP="127.0.0.1"
fi

# start the services
/app/sakura-sdk-server &
sleep 1
/app/sakura-dispatch-server &
sleep 1
/app/sakura-gate-server &
sleep 1
/app/sakura-game-server &

# print the url to create account
echo "To create account, visit http://$ACCESS_IP:21000/account/register"

# keep the container running
sleep infinity 
