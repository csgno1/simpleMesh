#!/bin/sh

# Path to the INI config file
INI_FILE="config.ini"

# Parse the INI file to get settings
SSID=$(awk -F'=' '/SSID/ {print $2}' $INI_FILE)
PASSWORD=$(awk -F'=' '/Password/ {print $2}' $INI_FILE)
GATEWAY_CHECK_INTERVAL=$(awk -F'=' '/GatewayCheckInterval/ {print $2}' $INI_FILE)

# Install necessary packages
opkg update
opkg install wpad-mesh-wolfssl batctl kmod-batman-adv

# Backup the current network and wireless configurations
cp /etc/config/network /etc/config/network.bak
cp /etc/config/wireless /etc/config/wireless.bak

# Configure eth0 to use DHCP
uci set network.lan.proto='dhcp'
uci delete network.lan.ipaddr  # Remove static IP if set
uci delete network.lan.netmask
uci delete network.lan.gateway
uci commit network

# Configure the wireless mesh interface
uci set wireless.radio0.disabled='0'
uci set wireless.radio0.channel='auto'
uci set wireless.radio0.hwmode='11g'
uci set wireless.radio0.type='mesh'
uci set wireless.radio0.device='radio0'

uci set wireless.mesh0=wifi-iface
uci set wireless.mesh0.network='lan'
uci set wireless.mesh0.mode='mesh'
uci set wireless.mesh0.mesh_id="$SSID"
uci set wireless.mesh0.encryption='psk2+ccmp'
uci set wireless.mesh0.key="$PASSWORD"
uci set wireless.mesh0.device='radio0'
uci set wireless.mesh0.disabled='0'

# Enable batman-adv on the mesh interface
uci set network.mesh0=interface
uci set network.mesh0.proto='batadv'
uci set network.mesh0.ifname='phy0-mesh0'
uci commit network
uci commit wireless

# Restart network and wireless services
/etc/init.d/network restart
wifi down && wifi up

# Start the gateway monitoring script (located in the same folder as this script)
SCRIPT_DIR=$(dirname "$0")
"$SCRIPT_DIR/monitor-gateway.sh" &

# Output completion message
echo "Mesh node setup completed for $SSID, eth0 configured for DHCP."
