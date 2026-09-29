#!/bin/sh

if [ ! -e "/sys/class/gpio/gpio15/value" ]; then
    echo "set fan high"
    echo 15 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio15/direction
    echo 1 > /sys/class/gpio/gpio15/value
fi

HOSTS_OTA_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/jetson/hosts/checksum`
HOSTS_CURRENT_CHECKSUM=`sha256sum /etc/hosts | awk '{print $1}'`
if [ "$HOSTS_OTA_CHECKSUM" != "" ] && [ "$HOSTS_OTA_CHECKSUM" != "$HOSTS_CURRENT_CHECKSUM" ]; then
    curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/jetson/hosts/hosts -o /tmp/hosts
    HOSTS_DOWNLOAD_CHECKSUM=`sha256sum /tmp/hosts | awk '{print $1}'`
    if [ "$HOSTS_OTA_CHECKSUM" = "$HOSTS_DOWNLOAD_CHECKSUM" ]; then
        mv /tmp/hosts /etc/hosts
    fi
fi
