#!/bin/sh

# Install required packages for USB storage support
opkg update
opkg install kmod-usb-storage block-mount kmod-fs-ext4 kmod-fs-vfat kmod-fs-ntfs ntfs-3g fdisk e2fsprogs usbutils

# Enable block-mount service
/etc/init.d/fstab enable
/etc/init.d/fstab start

# Create a mount point
MOUNT_DIR="/mnt/usb"
mkdir -p $MOUNT_DIR

# Detect available USB partitions
DEVICE=$(ls /dev/sd* 2>/dev/null | grep -E "/dev/sd[a-z][1-9]" | head -n 1)

# If a USB device is found, mount it
if [ -n "$DEVICE" ]; then
    echo "Mounting $DEVICE to $MOUNT_DIR..."
    mount "$DEVICE" "$MOUNT_DIR"
    echo "$DEVICE mounted successfully."
else
    echo "No USB device detected."
fi

# Configure automount using fstab
uci delete fstab.@mount[0] 2>/dev/null  # Remove existing mount entry if any
uci set fstab.@mount[-1]=mount
uci set fstab.@mount[-1].enabled='1'
uci set fstab.@mount[-1].device="$DEVICE"
uci set fstab.@mount[-1].target="$MOUNT_DIR"
uci commit fstab

echo "USB automount setup completed."
