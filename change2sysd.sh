#!/bin/bash
systemctl disable resolvconf
systemctl disable networking
systemctl stop resolvconf
systemctl stop networking
apt purge -y isc-dhcp-client dhcpcd5 ifupdown resolvconf
rm -f /etc/network/interfaces 
cat << _EOF_ > /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback
_EOF_
cat << _EOF_ > /etc/systemd/network/99-default.network
[Match]
Name=eth0

[Network]
DHCP=yes
_EOF_
systemctl enable systemd-resolved
systemctl enable systemd-networkd
systemctl start systemd-resolved
ln -sf /var/run/systemd/resolve/resolv.conf /etc/resolv.conf
systemctl start systemd-networkd
