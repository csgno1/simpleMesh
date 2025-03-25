#!/bin/sh

# Path to the INI config file
INI_FILE="config.ini"

# Parse the INI file to get settings
SSID=$(awk -F'=' '/SSID/ {print $2}' $INI_FILE)
PASSWORD=$(awk -F'=' '/Password/ {print $2}' $INI_FILE)
GATEWAY_CHECK_INTERVAL=$(awk -F'=' '/GatewayCheckInterval/ {print $2}' $INI_FILE)

# Install necessary packages
opkg update
opkg install wpad-mesh-openssl batctl kmod-batman-adv

# Backup the current wireless configuration
cp /etc/config/wireless /etc/config/wireless.bak

# Modify the wireless configuration to set up mesh node
uci set wireless.radio0.disabled='0'
uci set wireless.radio0.channel='auto'
uci set wireless.radio0.hwmode='11g'
uci set wireless.radio0.htmode='HT20'

# Create mesh interface
uci delete wireless.mesh0 2>/dev/null  # Remove previous config if it exists
uci set wireless.mesh0=wifi-iface
uci set wireless.mesh0.device='radio0'
uci set wireless.mesh0.network='mesh'
uci set wireless.mesh0.mode='mesh'
uci set wireless.mesh0.mesh_id="$SSID"
uci set wireless.mesh0.encryption='psk2+ccmp'
uci set wireless.mesh0.key="$PASSWORD"
uci set wireless.mesh0.disabled='0'

# Commit and restart WiFi
uci commit wireless
wifi

# Configure eth0 to use DHCP
uci set network.lan.proto='dhcp'
uci delete network.lan.ipaddr
uci delete network.lan.netmask
uci delete network.lan.gateway
uci delete network.lan.dns

# Configure batman-adv
uci delete network.mesh 2>/dev/null  # Remove old mesh config if it exists
uci set network.mesh=interface
uci set network.mesh.proto='batadv'
uci set network.mesh.mesh='bat0'

# Configure batman-adv mesh interface
uci delete network.bat0 2>/dev/null
uci set network.bat0=interface
uci set network.bat0.proto='batadv_hardif'
uci set network.bat0.master='bat0'
uci set network.bat0.ifname='mesh0'

# Commit and restart network
uci commit network
/etc/init.d/network restart

# Optional: Start gateway monitoring script if it exists
SCRIPT_DIR="$(dirname "$0")"
if [ -f "$SCRIPT_DIR/monitor-gateway.sh" ]; then
    chmod +x "$SCRIPT_DIR/monitor-gateway.sh"
    "$SCRIPT_DIR/monitor-gateway.sh" &
fi

# Output to indicate setup completion
echo "Mesh node setup completed for $SSID, eth0 configured for DHCP"
