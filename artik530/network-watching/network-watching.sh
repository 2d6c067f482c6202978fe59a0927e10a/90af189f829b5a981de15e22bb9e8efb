#!/bin/sh

LOG_DIR="/tmp/log"
BACKUP_DIR="/log"
LOG_FILE="$LOG_DIR/network-watching.log"
RETRY_COUNT=0
PING_GOOGLE_FAIL_COUNT=0
MAX_RETRIES=3
MAX_GOOGLE_FAILS=4

# Xác định interface dựa trên KIND
case "$KIND" in
    lan) INTERFACE="eth0" ;;
    wifi) INTERFACE="wlan0" ;;
    *) echo "[`date`] ERROR: Unknown network kind: $KIND" >> "$LOG_FILE"; exit 1 ;;
esac

# Hàm log chỉ ghi vào file, không in ra màn hình
function log_message() {
    echo "[`date`] $1" >> "$LOG_FILE"
}

function do_network_update() {
    log_message "Configuring $KIND ($MODE) mode"
    if [ "$MODE" = "dhcp" ]; then
        ip addr flush dev "$INTERFACE"
        
        # Kill dhclient theo PID trong file
        DHCP_PID_FILE="/run/dhclient.$INTERFACE.pid"
        if [ -f "$DHCP_PID_FILE" ]; then
            kill -9 $(cat "$DHCP_PID_FILE") 2>/dev/null
            rm -f "$DHCP_PID_FILE"
        fi
        
        dhclient -pf "$DHCP_PID_FILE" "$INTERFACE"
    elif [ "$MODE" = "static" ]; then
        ifdown "$INTERFACE" && ifup "$INTERFACE"
        systemctl restart networking
    fi
    sleep 10
}

function restart_interface() {
    log_message "Restarting network interface ($KIND)..."
    timeout 10 ifdown "$INTERFACE" && timeout 10 ifup "$INTERFACE"
    systemctl restart networking
    sleep 10
}

function backup_logs() {
    TIMESTAMP=$(date +"%d.%m.%y_%H.%M.%S")
    BACKUP_FILE="$BACKUP_DIR/network_log_$TIMESTAMP.tar.gz"
    log_message "Compressing logs to $BACKUP_FILE..."
    tar -czf "$BACKUP_FILE" -C "$(dirname "$LOG_DIR")" "$(basename "$LOG_DIR")"
    log_message "Log backup completed: $BACKUP_FILE"
}

while true; do
    # Cải tiến lấy GATEWAY_IP chính xác theo interface
    GATEWAY_IP=$(ip route show dev "$INTERFACE" | awk '/default/ {print $3}' | head -n 1)

    if [ -z "$GATEWAY_IP" ]; then
        log_message "ERROR: Could not determine gateway IP for $INTERFACE!"
        PING_GATEWAY=1
    else
        ping -c 1 "$GATEWAY_IP" > /dev/null 2>&1
        PING_GATEWAY=$?
    fi

    # Kiểm tra kết nối Internet bằng ping hoặc wget
    if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        PING_GOOGLE=0
    elif wget -q --spider http://google.com; then
        PING_GOOGLE=0
    else
        PING_GOOGLE=1
    fi

    if [ "$PING_GOOGLE" -eq 0 ]; then
        log_message "Ping to Google success"
        PING_GOOGLE_FAIL_COUNT=0
        RETRY_COUNT=0
    else
        PING_GOOGLE_FAIL_COUNT=$((PING_GOOGLE_FAIL_COUNT + 1))
        log_message "Ping to Google failed ($PING_GOOGLE_FAIL_COUNT/$MAX_GOOGLE_FAILS)"

        if [ "$PING_GOOGLE_FAIL_COUNT" -ge "$MAX_GOOGLE_FAILS" ]; then
            log_message "Google unreachable for $MAX_GOOGLE_FAILS times. Backing up logs & rebooting..."
            backup_logs
            [ "$(id -u)" -eq 0 ] && reboot || log_message "ERROR: Requires root to reboot!"
        fi
    fi

    if [ "$PING_GOOGLE" -ne 0 ] && [ "$PING_GATEWAY" -ne 0 ]; then
        log_message "No internet & gateway unreachable, retry #$((RETRY_COUNT + 1))..."

        if [ "$RETRY_COUNT" -lt 2 ]; then
            do_network_update
        elif [ "$RETRY_COUNT" -eq 2 ]; then
            restart_interface
        else
            log_message "Network failed after $MAX_RETRIES attempts, backing up logs and rebooting..."
            backup_logs
            [ "$(id -u)" -eq 0 ] && reboot || log_message "ERROR: Requires root to reboot!"
        fi
        RETRY_COUNT=$((RETRY_COUNT + 1))
    fi

    sleep 300
done
