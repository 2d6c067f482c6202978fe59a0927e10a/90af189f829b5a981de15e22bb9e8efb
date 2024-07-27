RAW_CONTENT_BASE=https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/master
FILE_BASE=https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw

/etc/init.d/relay-agent disable
/etc/init.d/hc-module disable
/etc/init.d/hc-module stop
/etc/init.d/relay-agent stop

PM_RESTART_FLAG=0

if [ `du /tmp/log/ | awk '{print $1}'` -ge 10000 ]; then
        echo "clean log"
        cat /dev/null > /tmp/log/io-service.log
        cat /dev/null > /tmp/log/network-service.log
        cat /dev/null > /tmp/log/zigbee.log
        cat /dev/null > /tmp/log/PM.log
        cat /dev/null > /tmp/log/ip-bridge.log
        cat /dev/null > /tmp/log/ota.log
        cat /dev/null > /tmp/log/hcg1.log
        cat /dev/null > /tmp/log/bluetooth.log
        PM_RESTART_FLAG=1
fi

PM_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/process-manager/checksum`
PM_CURRENT_CHECKSUM=`sha256sum /processmanager/process-manager | awk '{print $1}'`
if [ "$PM_OTA_CHECKSUM" != "$PM_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/process-manager/process-manager -O /tmp/pm-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/pm-update | awk '{print $1}'`
        if [ "$PM_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/pm-update /processmanager/process-manager
                chmod +x /processmanager/process-manager
                PM_RESTART_FLAG=1
        fi
fi

if [ $PM_RESTART_FLAG == 1 ]; then
        echo "Restart"
        /etc/init.d/processmanager stop
        sleep 1
        /etc/init.d/processmanager start
fi

# update hc-module
HC_MODULE_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/master/mt7688/hc-module/checksum`
HC_MODULE_CURRENT_CHECKSUM=`sha256sum /hc-module/hc-module | awk '{print $1}'`
if [ "$HC_MODULE_OTA_CHECKSUM" != "$HC_MODULE_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/hc-module/hc-module -O /tmp/hc-module-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/hc-module-update | awk '{print $1}'`
        if [ "$HC_MODULE_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/hc-module-update /hc-module/hc-module
                chmod +x /hc-module/hc-module
        fi
fi
##################

# update relay-agent
RELAY_AGENT_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/relay-agent/checksum`
RELAY_AGENT_CURRENT_CHECKSUM=`sha256sum /relay-agent/relay-agent | awk '{print $1}'`
if [ "$RELAY_AGENT_OTA_CHECKSUM" != "$RELAY_AGENT_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/relay-agent/relay-agent -O /tmp/relay-agent-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/relay-agent-update | awk '{print $1}'`
        if [ "$RELAY_AGENT_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/relay-agent-update /relay-agent/relay-agent
                chmod +x /relay-agent/relay-agent
        fi
fi
##################

# update ip
IP_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/ip-bridge/checksum`
IP_CURRENT_CHECKSUM=`sha256sum /ip-bridge/ip | awk '{print $1}'`
if [ "$IP_OTA_CHECKSUM" != "$IP_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/ip-bridge/ip -O /tmp/ip-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/ip-update | awk '{print $1}'`
        if [ "$IP_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/ip-update /ip-bridge/ip
                chmod +x /ip-bridge/ip
        fi
fi
##################

# update hcg1
HCG1_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/hcg1/checksum`
HCG1_CURRENT_CHECKSUM=`sha256sum /hcg1/hcg1 | awk '{print $1}'`
if [ "$HCG1_OTA_CHECKSUM" != "$HCG1_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/master/mt7688/hcg1/hcg1 -O /tmp/hcg1-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/relay-agent-update | awk '{print $1}'`
        if [ "$HCG1_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/hcg1-update /hcg1/hcg1
                chmod +x /hcg1/hcg1
        fi
fi
##################

# update io-service
IO_SERVICE_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/io-service/checksum`
IO_SERVICE_CURRENT_CHECKSUM=`sha256sum /io-service/io-service | awk '{print $1}'`
if [ "$IO_SERVICE_OTA_CHECKSUM" != "$IO_SERVICE_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/io-service/io-service -O /tmp/io-service-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/io-service-update | awk '{print $1}'`
        if [ "$IO_SERVICE_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/io-service-update /io-service/io-service
                chmod +x /io-service/io-service
        fi
fi
##################

# update zigbee
ZIGBEE_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/zigbee/checksum`
ZIGBEE_SERVICE_CURRENT_CHECKSUM=`sha256sum /zigbee/zigbee | awk '{print $1}'`
if [ "$ZIGBEE_OTA_CHECKSUM" != "$ZIGBEE_SERVICE_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/zigbee/zigbee -O /tmp/zigbee-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/zigbee-update | awk '{print $1}'`
        if [ "$ZIGBEE_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/zigbee-update /zigbee/zigbee
                chmod +x /zigbee/zigbee
        fi
fi
##################

# update bluetooth
BLUETOOTH_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/bluetooth/checksum`
BLUETOOTH_CURRENT_CHECKSUM=`sha256sum /bluetooth/bluetooth | awk '{print $1}'`
if [ "$BLUETOOTH_OTA_CHECKSUM" != "$BLUETOOTH_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/bluetooth/bluetooth -O /tmp/bluetooth-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/bluetooth-update | awk '{print $1}'`
        if [ "$BLUETOOTH_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/bluetooth-update /bluetooth/bluetooth
                chmod +x /bluetooth/bluetooth
        fi
fi
##################

# update ota-app
OTA_APP_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/ota-app/checksum`
OTA_APP_CURRENT_CHECKSUM=`sha256sum /ota-app/ota-app | awk '{print $1}'`
if [ "$OTA_APP_OTA_CHECKSUM" != "$OTA_APP_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/mt7688/ota-app/ota-app -O /tmp/ota-app-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/ota-app-update | awk '{print $1}'`
        if [ "$OTA_APP_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/ota-app-update /ota-app/ota-app
                chmod +x /ota-app/ota-app
        fi
fi
##################

# update network-service
NETWORK_OTA_CHECKSUM=`curl -s $RAW_CONTENT_BASE/mt7688/network-service/checksum`
NETWORK_CURRENT_CHECKSUM=`sha256sum /network-service/network-service | awk '{print $1}'`
if [ "$NETWORK_OTA_CHECKSUM" != "$NETWORK_CURRENT_CHECKSUM" ]; then
        wget $FILE_BASE/network/network-service -O /tmp/network-service-update
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/network-service-update | awk '{print $1}'`
        if [ "$NETWORK_OTA_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/network-service-update /network-service/network-service
                chmod +x /network-service/network-service
        fi
fi
##################