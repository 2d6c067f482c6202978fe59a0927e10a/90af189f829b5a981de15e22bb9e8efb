#!/bin/sh

echo "RK3588 github update"

HC_CONFIG_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/rk3588/hc-config/checksum`
HC_CONFIG_CURRENT_CHECKSUM=`sha256sum /etc/smarthome/hc-config.json.bk | awk '{print $1}'`
if [ "$HC_CONFIG_CURRENT_CHECKSUM" != "" ] && [ "$HC_CONFIG_CHECKSUM" != "$HC_CONFIG_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/blob/master/rk3588/hc-config/MergeConfigFile -O /tmp/MergeConfigFile
        wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/rk3588/hc-config/hc-config.json.bk -O /tmp/hc-config-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/hc-config-update | awk '{print $1}'`
        echo "$HC_CONFIG_CHECKSUM $DOWNLOAD_CHECKSUM"
        if [ "$HC_CONFIG_CHECKSUM" -eq "$DOWNLOAD_CHECKSUM" ]; then
                RANDOM=`head -c 200 /dev/urandom | tr -dc '0-9'  | head -n 1`
                SLEEP_TIME=`expr $RANDOM % 3600`
                mv /tmp/hc-config-update /etc/smarthome/hc-config.json.bk
                chmod +x /tmp/MergeConfigFile
                /tmp/MergeConfigFile -o /etc/smarthome/hc-config.json -n /etc/smarthome/hc-config.json.bk -l /etc/smarthome/hc-config.json
                sleep $SLEEP_TIME && systemctl restart process-manager.service &
        fi 
fi
