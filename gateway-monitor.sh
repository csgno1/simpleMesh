#!/bin/sh

# Path to the INI file
INI_FILE="config.ini"

# Default values
DEFAULT_GATEWAY_CHECK_INTERVAL=60
GATEWAY_IP="8.8.8.8"

# Read the gateway check interval from the INI file if it exists
if [ -f "$INI_FILE" ]; then
    GATEWAY_CHECK_INTERVAL=$(awk -F'=' '/GatewayCheckInterval/ {print $2}' "$INI_FILE" | tr -d '[:space:]')
else
    echo "Warning: config.ini not found! Using default check interval."
    GATEWAY_CHECK_INTERVAL=$DEFAULT_GATEWAY_CHECK_INTERVAL
fi

# Validate GATEWAY_CHECK_INTERVAL (ensure it's a number)
if ! echo "$GATEWAY_CHECK_INTERVAL" | grep -qE '^[0-9]+$'; then
    echo "Invalid GatewayCheckInterval value in config.ini. Using default: $DEFAULT_GATEWAY_CHECK_INTERVAL seconds."
    GATEWAY_CHECK_INTERVAL=$DEFAULT_GATEWAY_CHECK_INTERVAL
fi

# Function to check internet connection via eth0
check_gateway_connection() {
    # Ensure eth0 exists
    if ! ip link show eth0 &> /dev/null; then
        echo "Error: eth0 interface does not exist!"
        return 2
    fi

    # Check if eth0 is up
    if ip link show eth0 | grep -q "state UP"; then
        # Check if we can reach the gateway
        if ip route get $GATEWAY_IP &> /dev/null; then
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

    case $CONNECTION_STATUS in
        0) echo "Gateway is available. No action needed." ;;
        1) echo "No internet connection. Rechecking..." ;;
        2) echo "eth0 interface is down or missing. Rechecking..." ;;
    esac

    # Sleep for the configured interval before checking again
    sleep "$GATEWAY_CHECK_INTERVAL"
done
