# simpleMesh v0.1 - a simple, easily deployed, mesh wireless network built using Raspberry PIs

## Assumptions...

    Start with Openwrt images for Raspberry PIs, version n.nn (TBD)
    Internet gateway attaches at eth0
    If internet is available on eth0, it's a gateway node.
    If nothing is available on eth0, it's a mesh node.

## Getting started

### Set up wired network manually
    vi /etc/config/network<br>
### config interface 'wan'
      option proto 'dhcp'<br>
      option ifname 'eth0'  # Replace with your WAN interface name<br>
      option peerdns '1'    # (Optional) Use ISP-provided DNS<br>
      option defaultroute '1'<br>
  <br>
  /etc/init.d/network restart<br>
<br>
### Install git:<br>
    opkg update<br>
    opgk install git<br>
    opkg install git-http<br>
<br>
### Clone repo:<br>
https://github.com/csgno1/simpleMesh.git<br>
<br>
### change to the simpleMesh folder.<br>
<br>
### Edit config.ini as appropriate.<br>
<br>
### Run the setup script once:<br>
    chmod +x mesh-setup.sh<br>
    ./mesh-setup.sh<br>
<br>
### Start gateway monitoring:<br>
    chmod +x monitor-gateway.sh<br>
    ./monitor-gateway.sh &<br>
### Note: After testing, set up the gateway monitor as a service.<br>
<br>
