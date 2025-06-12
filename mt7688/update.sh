#!/bin/sh

# /etc/init.d/health-check stop
# /etc/init.d/health-check disable
# /etc/init.d/hc-module stop
# /etc/init.d/hc-module disable

if [ -n "$(cat /etc/config/hc-config.json | grep firmware_version | grep 2.0.34)" ]; then
    OTA_OTA_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/mt7688/ota-app/checksum`Add commentMore actions
    OTA_CURRENT_CHECKSUM=`sha256sum /ota-app/ota-app | awk '{print $1}'`
    if [ "$OTA_OTA_CHECKSUM" != "" ] && [ "$OTA_OTA_CHECKSUM" != "$OTA_CURRENT_CHECKSUM" ]; then
            wget --timeout=10 https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/refs/heads/master/mt7688/ota-app/ota-app -O /tmp/ota-update
            DOWNLOAD_CHECKSUM=`sha256sum /tmp/ota-update | awk '{print $1}'`
            if [ "$OTA_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                    RANDOM=`head -c 200 /dev/urandom | tr -dc '0-9'  | head -n 1`
                    SLEEP_TIME=`expr $RANDOM % 3600`
                    mv /tmp/ota-update /ota-app/ota-app
                    chmod +x /ota-app/ota-app
                    sleep $SLEEP_TIME && /etc/init.d/ota-app restart &
            fi 
    fi
else
    echo "Firmware version is not 2.0.34."
fi