#!/bin/sh

# Define the path to the log file
path_log="/tmp/log/health_check.log"

# Initialize the failure counters
agent_fail_times=0
hc_fail_times=0

# Function to check health of relay agent
health_check_relay_agent() {
    STATUS=$(curl --connect-timeout 2 -m 3 -s -o /dev/null -w "%{http_code}" localhost:10000/api/ping)
    
    if [ "$STATUS" != "200" ]; then
        # Increment the failure counter
        agent_fail_times=$((agent_fail_times + 1))
        
        # Log the failure
        echo "[$(date)] agent --> fail=$agent_fail_times time" >> "$path_log"
        
        # If 5 consecutive failures, restart the service
        if [ "$agent_fail_times" -ge 5 ]; then
            agent_fail_times=0
            /etc/init.d/relay-agent restart
            # Log the restart action
            echo "[$(date)] agent --> not response: restart" >> "$path_log"
        fi
    else
        # Reset counter if the status is 200 (healthy) and don't log anything
        agent_fail_times=0
    fi
}

# Function to check health of the HC module
health_check_hc_module() {
    STATUS=$(curl --connect-timeout 2 -m 3 -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/ping)
    
    if [ "$STATUS" != "200" ]; then
        # Increment the failure counter
        hc_fail_times=$((hc_fail_times + 1))
        
        # Log the failure
        echo "[$(date)] hc_module --> fail=$hc_fail_times time" >> "$path_log"
        
        # If 5 consecutive failures, restart the service
        if [ "$hc_fail_times" -ge 5 ]; then
            hc_fail_times=0
	    /etc/init.d/hc-module  restart
            # Log the restart action
            echo "[$(date)] hc_module --> not response: restart" >> "$path_log"
        fi
    else
        # Reset counter if the status is 200 (healthy) and don't log anything
        hc_fail_times=0
    fi
}

# Loop to keep checking the health of services
while true; do
    health_check_relay_agent
    health_check_hc_module
    sleep 30
done

