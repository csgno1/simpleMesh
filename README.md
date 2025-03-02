# simpleMesh - a simple mesh wireless network built using Raspberry PIs and easily deployed

Assumptions...
Start with Openwrt images for Raspberry PIs, version n.nn (TBD)
Internet gateway attaches at eth0
If internet is available on eth0 it's a gateway node.
If nothing is attached to eth0, it's a mesh node.

# Getting started

Set up wired network manually
  nano /etc/config/network

  config interface 'wan'
      option proto 'dhcp'
      option ifname 'eth0'  # Replace with your WAN interface name
      option peerdns '1'    # (Optional) Use ISP-provided DNS
      option defaultroute '1'
  
  /etc/init.d/network restart


Clone repo:
https://github.com/csgno1/simpleMesh.git

Edit mesh_config.ini as appropriate.

Run the setup script once:
    chmod +x mesh-setup.sh
    ./mesh-setup.sh

Start gateway monitoring:
    chmod +x monitor-gateway.sh
    ./monitor-gateway.sh &
Note: After testing, set up the gateway monitor as a service.
