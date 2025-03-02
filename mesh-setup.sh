#!/bin/sh

# Path to the INI config file
INI_FILE="mesh_config.ini"

# Parse the INI file to get settings
SSID=$(awk -F'=' '/SSID/ {print $2}' $INI_FILE)
PASSWORD=$(awk -F'=' '/Password/ {print $2}' $INI_FILE)
GATEWAY_CHECK_INTERVAL=$(awk -F'=' '/GatewayCheckInterval/ {print $2}' $INI_FILE)

# Install necessary packages
opkg update
opkg install wpad-mesh-wolfssl batctl

# Backup the current wireless configuration
cp /etc/config/wireless /etc/config/wireless.bak

# Modify the wireless configuration to set up mesh node
uci set wireless.radio0.disabled='0'
uci set wireless.radio0.channel='auto'
uci set wireless.radio0.hwmode='11g'
uci set wireless.radio0.type='mesh'
uci set wireless.radio0.device='radio0'

# Setup SSID, encryption, 802.11r and WDS
uci set wireless.mesh0.ssid=$SSID
uci set wireless.mesh0.encryption='psk2+ccmp'
uci set wireless.mesh0.key=$PASSWORD
uci set wireless.mesh0.ieee80211r='1'
uci set wireless.mesh0.ft_over_ds='1'
uci set wireless.mesh0.ft_psk_generate_local='1'
uci set wireless.mesh0.mobility_domain='1234'
uci set wireless.mesh0.reassociation_deadline='100'

# Enable WDS for wireless nodes to connect
uci set wireless.mesh0.mode='sta'
uci set wireless.mesh0.device='radio0'
uci set wireless.mesh0.disabled='0'

# Apply the configuration
uci commit wireless
wifi

# Optional: Setup gateway monitoring script as a service
/etc/init.d/gateway_monitor enable
/etc/init.d/gateway_monitor start

# Output to indicate setup completion
echo "Mesh node setup completed for $SSID"
