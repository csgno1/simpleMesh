# simpleMesh v0.1 - a simple, easily deployed, mesh wireless network built using Raspberry PIs

## Assumptions...

- Start with Openwrt images for Raspberry PIs, version n.nn (TBD)
- Internet gateway attaches at eth0
- If internet is available on eth0, it's a gateway node.
- If nothing is available on eth0, it's a mesh node.

## Getting started

### Set up wired network manually
    vi /etc/config/network<br>
### config interface 'wan'
      option proto 'dhcp'<br>
      option ifname 'eth0'  # Replace with your WAN interface name<br>
      option peerdns '1'    # (Optional) Use ISP-provided DNS<br>
      option defaultroute '1'<br>

    /etc/init.d/network restart

### Install git:
    opkg update
    opgk install git
    opkg install git-http

### Clone repo:<br>
    git clone https://github.com/csgno1/simpleMesh.git

### Change to the simpleMesh folder.

### Edit config.ini as appropriate.

### Run the setup script once:
    chmod +x mesh-setup.sh
    ./mesh-setup.sh

### Start gateway monitoring:
    chmod +x monitor-gateway.sh
    ./monitor-gateway.sh &
### Note: After testing, set up the gateway monitor as a service.

