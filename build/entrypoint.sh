#!/bin/sh
# generate the config files
/app/sdkserver &
/app/dispatch &
/app/dbgate &
/app/gateserver &
/app/gameserver &
sleep 5


# replace the ACCESS_IP in the config files
killall sdkserver dispatch dbgate gateserver gameserver
if [ -n "$ACCESS_IP" ]; then
    echo "ACCESS_IP is set to $ACCESS_IP"
    sed -i 's/127.0.0.1/'$ACCESS_IP'/g' /app/*.toml
    sed -i 's/localhost/'$ACCESS_IP'/g' /app/*.toml
else
    echo "ACCESS_IP is not set, using default (127.0.0.1)."
    ACCESS_IP="127.0.0.1"
fi

# update dispatch_url in the database
psql -h $ACCESS_IP -U postgres -d hk4e \
-c "UPDATE t_region_config SET dispatch_url = 'http://$ACCESS_IP:21041/query_cur_region' WHERE id = 1;"

# start the services
/app/sdkserver &
sleep 1
/app/dispatch &
sleep 1
/app/dbgate &
sleep 1
/app/gateserver &
sleep 1
/app/gameserver &
sleep 1

# print the url to create account
echo "To create account, visit http://$ACCESS_IP:21000/account/register"

# keep the container running
sleep infinity 
