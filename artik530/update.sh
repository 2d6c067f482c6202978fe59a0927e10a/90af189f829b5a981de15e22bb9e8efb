#!/bin/sh

chmod 755 /app/script/network-watching.sh

NET_WATCHING_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/network-watching/checksum`
NET_WATCHING_CURRENT_CHECKSUM=`sha256sum /app/script/network-watching.sh | awk '{print $1}'`
if [ "$NET_WATCHING_CHECKSUM" != "" ] && [ "$NET_WATCHING_CHECKSUM" != "$NET_WATCHING_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/network-watching/network-watching.sh -O /tmp/network-watching-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/network-watching-tmp | awk '{print $1}'`
        if [ "$NET_WATCHING_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/network-watching-tmp /app/script/network-watching.sh
                chmod 755 /app/script/network-watching.sh
                systemctl restart network-watching
        fi
fi

# update hotfix hc-module
HC_MODULE_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/fix-hc-module-artik530/artik530/hc-module/checksum`
HC_MODULE_CURRENT_CHECKSUM=`sha256sum /hc-module/hc-module | awk '{print $1}'`
if [ "$HC_MODULE_CHECKSUM" != "" ] && [ "$HC_MODULE_CHECKSUM" != "$HC_MODULE_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/refs/heads/master/artik530/hc-module/hc-module -O /tmp/hc-module-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/hc-module-tmp | awk '{print $1}'`
        if [ "$HC_MODULE_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                systemctl stop hc-module
                mv /tmp/hc-module-tmp /hc-module/hc-module
                chmod 755 /hc-module/hc-module
                systemctl restart hc-module
        fi
fi

# remove history log and hc-module device-logs
rm /log/*
rm /hc-module/device-logs
