# simpleMesh - a simple, easily deployed, mesh wireless network built using Raspberry PIs

## Assumptions...

- Start with Openwrt images for Raspberry PIs, version 24.10
- Internet gateway attaches at eth0
- If internet is available on eth0, it's a gateway node.
- If nothing is available on eth0, it's a mesh node.

## Getting started

### Set up wired network manually
    vi /etc/config/network
### config interface 'wan'
    option proto 'dhcp'
    option ifname 'eth0'  # Replace with your WAN interface name
    option peerdns '1'    # (Optional) Use ISP-provided DNS
    option defaultroute '1'

### Restart network

    /etc/init.d/network restart

### Install git:
    opkg update
    opgk install git
    opkg install git-http

### Clone repo:<br>
    git clone https://github.com/csgno1/simpleMesh.git

### Change to the simpleMesh folder.
    cd simpleMesh

### Edit config.ini as appropriate.

    [MeshNetwork]
    SSID=mesh1
    Password=ChangeMe
    GatewayCheckInterval=60

### Run the setup script once:
    chmod +x mesh-setup.sh
    ./mesh-setup.sh

### Start gateway monitoring:
    chmod +x monitor-gateway.sh
    ./monitor-gateway.sh &
### Note: After testing, set up the gateway monitor as a service.

### Releases
0.01 - Not a release, not yet functional
