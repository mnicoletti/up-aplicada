#!/bin/bash
IF_FILE="/etc/network/interfaces"
IPTABLES_SERVICE="/etc/systemd/system/iptables.service"
LOCAL_DIR="/usr/local/aplicada/up-aplicada/cafirewall"

# Configuracion de interfaces
cat > ${IF_FILE} << EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet dhcp

allow-hotplug enp0s8
iface enp0s8 inet static
    address 192.168.10.161
    netmask 255.255.255.224

EOF

# Configuracion de iptables como servicio
cp ${LOCAL_DIR}/iptables.service ${IPTABLES_SERVICE}
systemctl daemon-reload
systemctl enable iptables.service
systemctl start iptables.service

# Permitir forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
