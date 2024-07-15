/etc/init.d/relay-agent disable
/etc/init.d/hc-module disable
/etc/init.d/hc-module stop
/etc/init.d/relay-agent stop

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
fi

