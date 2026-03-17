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

# remove history log and hc-module device-logs
rm -f /log/*
rm -f /hc-module/device-logs

NEED_RESTART_DEVICE_EXPORTER=false
NEED_RESTART_RELAY_AGENT=false


# device-exporter.yaml
DEVICE_EXPORTER_YAML_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/device-exporter-yaml/checksum`
DEVICE_EXPORTER_YAML_CURRENT_CHECKSUM=`sha256sum /device-exporter/device-exporter.yaml | awk '{print $1}'`
if [ "$DEVICE_EXPORTER_YAML_CHECKSUM" != "" ] && [ "$DEVICE_EXPORTER_YAML_CHECKSUM" != "$DEVICE_EXPORTER_YAML_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/device-exporter-yaml/device-exporter.yaml -O /tmp/device-exporter-yaml-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/device-exporter-yaml-tmp | awk '{print $1}'`
        if [ "$DEVICE_EXPORTER_YAML_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/device-exporter-yaml-tmp /device-exporter/device-exporter.yaml
                NEED_RESTART_DEVICE_EXPORTER=true
        fi
fi

# device-exporter.eth0.conf
DEVICE_EXPORTER_ETH0_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/device-exporter-conf/eth0-checksum`
DEVICE_EXPORTER_ETH0_CURRENT_CHECKSUM=`sha256sum /device-exporter/device-exporter.eth0.conf | awk '{print $1}'`
if [ "$DEVICE_EXPORTER_ETH0_CHECKSUM" != "" ] && [ "$DEVICE_EXPORTER_ETH0_CHECKSUM" != "$DEVICE_EXPORTER_ETH0_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/device-exporter-conf/device-exporter.eth0.conf -O /tmp/device-exporter-eth0-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/device-exporter-eth0-tmp | awk '{print $1}'`
        if [ "$DEVICE_EXPORTER_ETH0_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/device-exporter-eth0-tmp /device-exporter/device-exporter.eth0.conf
                NEED_RESTART_DEVICE_EXPORTER=true
        fi
fi

# device-exporter.wlan0.conf
DEVICE_EXPORTER_WLAN0_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/device-exporter-conf/wlan0-checksum`
DEVICE_EXPORTER_WLAN0_CURRENT_CHECKSUM=`sha256sum /device-exporter/device-exporter.wlan0.conf | awk '{print $1}'`
if [ "$DEVICE_EXPORTER_WLAN0_CHECKSUM" != "" ] && [ "$DEVICE_EXPORTER_WLAN0_CHECKSUM" != "$DEVICE_EXPORTER_WLAN0_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/device-exporter-conf/device-exporter.wlan0.conf -O /tmp/device-exporter-wlan0-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/device-exporter-wlan0-tmp | awk '{print $1}'`
        if [ "$DEVICE_EXPORTER_WLAN0_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/device-exporter-wlan0-tmp /device-exporter/device-exporter.wlan0.conf
                NEED_RESTART_DEVICE_EXPORTER=true
        fi
fi

# device-exporter
DEVICE_EXPORTER_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/device-exporter/checksum`
DEVICE_EXPORTER_CURRENT_CHECKSUM=`sha256sum /device-exporter/device-exporter | awk '{print $1}'`
if [ "$DEVICE_EXPORTER_CHECKSUM" != "" ] && [ "$DEVICE_EXPORTER_CHECKSUM" != "$DEVICE_EXPORTER_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/refs/heads/master/artik530/device-exporter/device-exporter -O /tmp/device-exporter-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/device-exporter-tmp | awk '{print $1}'`
        if [ "$DEVICE_EXPORTER_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/device-exporter-tmp /device-exporter/device-exporter
                chmod 755 /device-exporter/device-exporter
                NEED_RESTART_DEVICE_EXPORTER=true
        fi
fi


# relay-agent
RELAY_AGENT_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/relay-agent/checksum`
RELAY_AGENT_CURRENT_CHECKSUM=`sha256sum /relay-agent/relay-agent | awk '{print $1}'`
if [ "$RELAY_AGENT_CHECKSUM" != "" ] && [ "$RELAY_AGENT_CHECKSUM" != "$RELAY_AGENT_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/refs/heads/master/artik530/relay-agent/relay-agent -O /tmp/relay-agent-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/relay-agent-tmp | awk '{print $1}'`
        if [ "$RELAY_AGENT_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/relay-agent-tmp /relay-agent/relay-agent
                chmod 755 /relay-agent/relay-agent
                NEED_RESTART_RELAY_AGENT=true
        fi
fi


# relay-agent.conf
RELAY_AGENT_CONF_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/relay-agent-conf/checksum`
RELAY_AGENT_CONF_CURRENT_CHECKSUM=`sha256sum /relay-agent/relay-agent.conf | awk '{print $1}'`
if [ "$RELAY_AGENT_CONF_CHECKSUM" != "" ] && [ "$RELAY_AGENT_CONF_CHECKSUM" != "$RELAY_AGENT_CONF_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/relay-agent-conf/relay-agent.conf -O /tmp/relay-agent-conf-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/relay-agent-conf-tmp | awk '{print $1}'`
        if [ "$RELAY_AGENT_CONF_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/relay-agent-conf-tmp /relay-agent/relay-agent.conf 
                NEED_RESTART_RELAY_AGENT=true
        fi
fi

if [ "$NEED_RESTART_DEVICE_EXPORTER" == "true" ]; then
        systemctl restart device-exporter.service
fi

if [ "$NEED_RESTART_RELAY_AGENT" == "true" ]; then
        systemctl restart relay-agent.service
fi

# hcg1 
HCG1_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/artik530/hcg1/checksum`
HCG1_CURRENT_CHECKSUM=`sha256sum /hcg1/hcg1 | awk '{print $1}'`
if [ "$HCG1_CHECKSUM" != "" ] && [ "$HCG1_CHECKSUM" != "$HCG1_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://github.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/raw/refs/heads/master/artik530/hcg1/hcg1 -O /tmp/hcg1-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/hcg1-tmp | awk '{print $1}'`
        if [ "$HCG1_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
                RANDOM=`head -c 200 /dev/urandom | tr -dc '0-9'  | head -n 1`
                SLEEP_TIME=`expr $RANDOM % 600`
                mv /tmp/hcg1-tmp /hcg1/hcg1
                chmod +x /hcg1/hcg1
                sleep $SLEEP_TIME && systemctl restart hcg1
        else
                rm -f /tmp/hcg1-tmp
        fi
fi