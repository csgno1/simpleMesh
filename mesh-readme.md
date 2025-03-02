# mesh-readme.md

Edit openwrt-mesh.ini as appropriate.

Run the setup script once:
    chmod +x mesh-setup.sh
    ./mesh-setup.sh

Start gateway monitoring:
    chmod +x monitor-gateway.sh
    ./monitor-gateway.sh &
Note: After testing, set up the gateway monitor as a service.


Features & Benefits:
✔ Mesh Setup Only Runs Once – No need to re-run the setup.
✔ Gateway Monitoring is Separate – Runs as a service and adapts dynamically.
✔ Configurable via INI File – No need to modify the script to change settings.
✔ Automatic Internet Gateway Selection – Nodes dynamically switch roles based on internet availability.
✔ Adjustable Check Interval – Prevents unnecessary network disruptions.

