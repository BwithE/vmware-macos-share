#!/bin/bash
clear

read -p "Where would you like to mount your shared folders?(ex: /home/user/share)" path
# Check if running on a virtual machine
if [[ $(dmesg | grep -i virtual) || $(systemd-detect-virt) ]]; then
    echo "This machine is a virtual machine."
# machine must be updated
# installs vmware tools if not already installed
# mount share drives on linux
    echo "INSTALLING AND MOUNTING VMWARE TOOLS FOR SHARED FOLDERS"
    sudo apt install open-vm-tools-desktop -y
    sudo mkdir /mnt/hgfs
    sudo /usr/bin/vmhgfs-fuse .host:/ /mnt/hgfs -o subtype=vmhgfs-fuse,allow_other
# echos settings to the bottom of /etc/fstab file
    sudo echo "vmhgfs-fuse       /mnt/hgfs       fuse    defaults,allow_other    0       0" >> /etc/fstab

# This line creates a link from the SHARE to be in the users home directory
# syntax: ln -s <shared folders> <path to link>
    #clear
    echo "MOUNTING SHARED FOLDERS TO THE HOME DIRECTORY"
    ln -s /mnt/hgfs/* $path
    clear
    echo "Please check '$path' for shared folders."
else
    echo "This machine is not a virtual machine."
fi

