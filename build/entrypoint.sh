#/bin/sh

# init config.json
if [ ! -f /app/config.json ]; then
    cp /app/config.json.bak /app/config.json
fi

# update mongodb uri
if [ -n "$MONGODB_URI" ]; then  
    sed -i 's|mongodb://localhost:27017|'$MONGODB_URI'|g' /app/config.json
fi

# access ip
if [ -n "$ACCESS_IP" ]; then
    sed -i 's|127.0.0.1|'$ACCESS_IP'|g' /app/config.json
    sed -i 's|localhost|'$ACCESS_IP'|g' /app/config.json
fi

# access port
ACCESS_PORT=${ACCESS_PORT:-11080}
jq '.server.http.bindPort = '$ACCESS_PORT'' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json

# language
# jq '.language.language = "zh_CN" | .language.document = "CHS"' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json

# account
if [ "$ACCOUNT_AUTO_CREATE" = "true" ]; then
    jq '.account.autoCreate = '$ACCOUNT_AUTO_CREATE'' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json
fi
if [ -n "$ACCOUNT_PERMISSIONS" ]; then
    jq '.account.defaultPermissions = [ '$ACCOUNT_PERMISSIONS' ]' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json
fi
ACCOUNT_DOMAIN=${ACCOUNT_DOMAIN:-"player"}
jq '.account.playerEmail = '$ACCOUNT_DOMAIN'' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json

# game quest mode
QUEST_MODE=${QUEST_MODE:-"false"}
jq '.server.game.gameOptions.questing.enabled = '$QUEST_MODE'' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json

# disable encryption
jq '.server.http.encryption.useEncryption = false | .server.http.encryption.useInRouting = false' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json

# disable console
jq '.server.game.enableConsole = false' /app/config.json > /app/config.json.tmp && mv /app/config.json.tmp /app/config.json

# start server
echo "Starting server $ACCESS_IP:$ACCESS_PORT"
java -jar /app/start.jar $@ &
sleep infinity
