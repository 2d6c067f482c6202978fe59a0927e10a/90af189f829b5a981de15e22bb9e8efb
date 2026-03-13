#!/bin/sh

# device-exporter.yaml
DEVICE_EXPORTER_YAML_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/ssd202d/device-exporter-yaml/checksum`
DEVICE_EXPORTER_YAML_CURRENT_CHECKSUM=`sha256sum /app/sysconfigs/device-exporter.yaml | awk '{print $1}'`
if [ "$DEVICE_EXPORTER_YAML_CHECKSUM" != "" ] && [ "$DEVICE_EXPORTER_YAML_CHECKSUM" != "$DEVICE_EXPORTER_YAML_CURRENT_CHECKSUM" ]; then
        wget --timeout=10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/ssd202d/device-exporter-yaml/device-exporter.yaml -O /tmp/device-exporter-yaml-tmp
        DOWNLOAD_CHECKSUM=`sha256sum /tmp/device-exporter-yaml-tmp | awk '{print $1}'`
        if [ "$DEVICE_EXPORTER_YAML_CHECKSUM" = "$DOWNLOAD_CHECKSUM" ]; then
                mv /tmp/device-exporter-yaml-tmp /app/sysconfigs/device-exporter.yaml
                /etc/init.d/device-exporter restart
        else
            rm -f /tmp/device-exporter-yaml-tmp
        fi
fi

CONFIG_FILE="/app/sysconfigs/hc-config.json"

# check file hc-config.json and type hc
if [ -f "$CONFIG_FILE" ]; then
    if grep -q '"hc_type" : "G2.1"' "$CONFIG_FILE"; then
        echo "change hc_type = G2.5 -> restart PM"
        /etc/init.d/S90process-manager stop
        rm -f "$CONFIG_FILE"
	      rm -f /app/sysconfigs/type_info.json
	      sleep 5
	      /etc/init.d/S90process-manager restart
	      echo "change $CONFIG_FILE"
    else
        echo "not update"
    fi
else
    echo "error"
fi

