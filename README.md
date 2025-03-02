# simpleMesh - a simple mesh wireless network built using Raspberry PIs and easily deployed

Assumptions...<br>
Start with Openwrt images for Raspberry PIs, version n.nn (TBD)<br>
Internet gateway attaches at eth0<br>
If internet is available on eth0 it's a gateway node.<br>
If nothing is available to eth0, it's a mesh node.<br>
<br>
# Getting started<br>
<br>
Set up wired network manually<br>
  nano /etc/config/network<br>
<br>
  config interface 'wan'<br>
      option proto 'dhcp'<br>
      option ifname 'eth0'  # Replace with your WAN interface name<br>
      option peerdns '1'    # (Optional) Use ISP-provided DNS<br>
      option defaultroute '1'<br>
  <br>
  /etc/init.d/network restart<br>
<br>
<br>
Clone repo:<br>
https://github.com/csgno1/simpleMesh.git<br>
<br>
change to the simpleMesh folder<br>
<br>
chmod 755 *.sh<br>
<br>
Edit config.ini as appropriate.<br>
<br>
Run the setup script once:<br>
    chmod +x mesh-setup.sh<br>
    ./mesh-setup.sh<br>
<br>
Start gateway monitoring:<br>
    chmod +x monitor-gateway.sh<br>
    ./monitor-gateway.sh &<br>
Note: After testing, set up the gateway monitor as a service.<br>
<br>
