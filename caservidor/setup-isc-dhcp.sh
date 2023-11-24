#!/bin/bash
DHCP_CONF="/etc/dhcp/dhcpd.conf"
DHCP_DEFAULT="/etc/default/isc-dhcp-server"

# Instalacion y configuracion de isc-dhcp-server
apt-get update
apt-get install isc-dhcp-server -y

# Configuracion de interfaces
cat > ${DHCP_DEFAULT} << EOF
INTERFACESv4="enp0s3"
EOF

# Configuracion de DHCP Server
cat > ${DHCP_CONF} << EOF
option domain-name-servers 1.1.1.1 1.0.0.1;

default-lease-time 30;
max-lease-time 60;
ddns-update-style none;
log-facility local7;

subnet 192.168.10.160 netmask 255.255.255.224 {
    range 192.168.10.171 192.168.10.190;
    option routers 192.168.10.161;
    option broadcast-address 192.168.10.191;
}

host cacit01 {
    hardware ethernet 08:00:27:4c:4c:01; # Reemplazar por la MAC de la VM
    fixed-address 192.168.10.163;
}

host cacit02 {
    hardware ethernet 08:00:27:4c:4c:02; # Reemplazar por la MAC de la VM
    fixed-address 192.168.10.164;
}
EOF

# Restart de isc-dhcp-server
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server
