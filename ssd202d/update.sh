#!/bin/sh
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
