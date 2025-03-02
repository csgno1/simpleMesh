#!/bin/sh

# Path to the INI file
INI_FILE="mesh_config.ini"
# Read the gateway check interval from the INI file
GATEWAY_CHECK_INTERVAL=$(awk -F'=' '/GatewayCheckInterval/ {print $2}' $INI_FILE)

# Gateway IP to ping (Google DNS server)
GATEWAY_IP="8.8.8.8"

# Function to check internet connection via eth0
check_gateway_connection() {
    # Check if eth0 is up
    if ip link show eth0 | grep -q "state UP"; then
        # Try pinging the gateway to check for internet connection
        if ping -c 1 $GATEWAY_IP &> /dev/null; then
            echo "Internet is connected."
            return 0
        else
            echo "Internet is not connected."
            return 1
        fi
    else
        echo "eth0 interface is down."
        return 2
    fi
}

# Main loop for monitoring the gateway
while true; do
    check_gateway_connection
    CONNECTION_STATUS=$?

    if [ $CONNECTION_STATUS -eq 0 ]; then
        # Internet is connected, perform gateway logic if needed
        # (e.g., selecting gateway node, etc.)
        echo "Gateway is available. No action needed."
    elif [ $CONNECTION_STATUS -eq 1 ]; then
        # Internet is not connected, handle this case
        echo "No internet connection. Rechecking..."
        # You can implement fallback logic here
    else
        # Interface is down, alert or handle this case
        echo "eth0 interface is down. Rechecking..."
    fi

    # Sleep for the configured interval before checking again
    sleep $GATEWAY_CHECK_INTERVAL
done
