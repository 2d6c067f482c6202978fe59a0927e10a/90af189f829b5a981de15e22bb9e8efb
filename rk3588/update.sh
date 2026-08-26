#!/bin/sh

echo "RK3588 github update"

LOG_CLEANUP_CRON='*/10 * * * * find /var/log -xdev -type f -size +10M -exec truncate -s 0 {} +'

if ! crontab -l 2>/dev/null | grep -Fqx "$LOG_CLEANUP_CRON"; then
    (crontab -l 2>/dev/null; printf '%s\n' "$LOG_CLEANUP_CRON") | crontab -
fi

systemctl stop gdm3
systemctl disable gdm3

ACTIVATOR_CLIENT_OTA_CHECKSUM=`curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/rk3588/activator-client/checksum`
ACTIVATOR_CLIENT_CURRENT_CHECKSUM=`sha256sum /etc/systemd/system/activator-client.service | awk '{print $1}'`
if [ "$ACTIVATOR_CLIENT_OTA_CHECKSUM" != "" ] && [ "$ACTIVATOR_CLIENT_OTA_CHECKSUM" != "$ACTIVATOR_CLIENT_CURRENT_CHECKSUM" ]; then
    curl -s --connect-timeout 10 https://raw.githubusercontent.com/2d6c067f482c6202978fe59a0927e10a/90af189f829b5a981de15e22bb9e8efb/refs/heads/master/rk3588/activator-client/activator-client.service -o /tmp/activator-client.service
    ACTIVATOR_CLIENT_DOWNLOAD_CHECKSUM=`sha256sum /tmp/activator-client.service | awk '{print $1}'`
    if [ "$ACTIVATOR_CLIENT_OTA_CHECKSUM" = "$ACTIVATOR_CLIENT_DOWNLOAD_CHECKSUM" ]; then
        mv /tmp/activator-client.service /etc/systemd/system/activator-client.service
        systemctl daemon-reload
        systemctl stop activator-client
    fi
fi
