#!/bin/sh

# PM_RESTART_FLAG=0

# if [ `du /tmp/log/ | awk '{print $1}'` -ge 10000 ]; then
#         echo "clean log"
#         cat /dev/null > /tmp/log/io-service.log
#         cat /dev/null > /tmp/log/network-service.log
#         cat /dev/null > /tmp/log/zigbee.log
#         cat /dev/null > /tmp/log/PM.log
#         cat /dev/null > /tmp/log/ip-bridge.log
#         cat /dev/null > /tmp/log/ota.log
#         cat /dev/null > /tmp/log/hcg1.log
#         cat /dev/null > /tmp/log/bluetooth.log
#         # PM_RESTART_FLAG=1
# fi

HEALTH_CHECK_OTA_CHECKSUM=`curl -s https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master/mt7688/health-check/checksum`
HEALTH_CHECK_CURRENT_CHECKSUM=`sha256sum /root/health-check.sh | awk '{print $1}'`
if [ "$HEALTH_CHECK_OTA_CHECKSUM" != "$HEALTH_CHECK_CURRENT_CHECKSUM" ]; then
        wget https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/master/mt7688/health-check/health-check.sh -O /tmp/health-check-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/health-check-update | awk '{print $1}'`
        if [ "$HEALTH_CHECK_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                /etc/init.d/health-check stop;
                mv /tmp/health-check-update /root/health-check.sh
                chmod +x /root/health-check.sh
                /etc/init.d/health-check restart;
        fi
fi

# if [ $PM_RESTART_FLAG == 1 ]; then
#         echo "Restart"
#         /etc/init.d/processmanager stop
#         sleep 1
#         /etc/init.d/processmanager start
# fi

# OTA_OTA_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/mt7688/ota-app/checksum`
# OTA_CURRENT_CHECKSUM=`sha256sum /ota-app/ota-app | awk '{print $1}'`
# if [ "$OTA_OTA_CHECKSUM" != "" ] && [ "$OTA_OTA_CHECKSUM" != "$OTA_CURRENT_CHECKSUM" ]; then
#         wget --timeout=10 https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/refs/heads/master/mt7688/ota-app/ota-app -O /tmp/ota-update
#         DOWNLOAD_CHECKSUM=`sha256sum /tmp/ota-update | awk '{print $1}'`
#         if [ "$OTA_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
#                 RANDOM=`head -c 200 /dev/urandom | tr -dc '0-9'  | head -n 1`
#                 SLEEP_TIME=`expr $RANDOM % 3600`
#                 mv /tmp/ota-update /ota-app/ota-app
#                 chmod +x /ota-app/ota-app
#                 sleep $SLEEP_TIME && /etc/init.d/ota-app restart &
#         fi 
# fi

# SYSUPGRADE_OTA_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/update-script-for-sysupdate/mt7688/sysupgrade/checksum`
# SYSUPGRADE_CURRENT_CHECKSUM=`sha256sum /etc/sysupgrade.conf | awk '{print $1}'`
# if [ "$SYSUPGRADE_OTA_CHECKSUM" != "" ] && [ "$SYSUPGRADE_OTA_CHECKSUM" != "$SYSUPGRADE_CURRENT_CHECKSUM" ]; then
#         wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/mt7688/sysupgrade/sysupgrade.conf -O /tmp/sysupgrade-tmp
#         DOWNLOAD_CHECKSUM=`sha256sum /tmp/sysupgrade-tmp | awk '{print $1}'`
#         if [ "$SYSUPGRADE_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
#                 mv /tmp/sysupgrade-tmp /etc/sysupgrade.conf
#         fi
# fi

# # create file /tmp/2025-04-18 and set create date to 2025-04-18
# # check if /tmp/2025-04-18 is new than bip32 => bip32 old than 2025-04-18
# touch -d "2025-04-18" /tmp/2025-04-18
# if [ -n "$(find /tmp/2025-04-18 -type f -newer /etc/config/bip32_key.json)" ]; then
#     rm -f /etc/config/bip32_key.json
#     /etc/init.d/activator-client restart
#     /etc/init.d/relay-agent restart
# fi
# rm /tmp/2025-04-18