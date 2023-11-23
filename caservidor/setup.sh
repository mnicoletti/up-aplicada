#!/bin/bash
# El script asume que las particiones fueron realizadas
# manualmente de acuerdo a la documentación.
# No es posible automatizar el particionado de discos con
# fdisk, se debería utilizar parted o sfdisk.

# Variables
IF_FILE="/etc/network/interfaces"
LOCAL_DIR="/usr/local/aplicada/up-aplicada/caservidor"

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
iface enp0s3 inet static
	address 192.168.10.162
	netmask 255.255.255.224
	gateway 192.168.10.161
EOF

# Restart de interfaces
ifdown enp0s3
ifup enp0s3

# Instalacion de paquetes
apt-get update
apt-get install mdadm -y

# Creacion de RAID
mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Creacion de PV en LVM
pvcreate /dev/md0
pvcreate /dev/sdd1
pvcreate /dev/sde1
pvcreate /dev/sde2
pvcreate /dev/sde3

# Creacion de VG en LVM
vgcreate backups-vg /dev/md0
vgcreate data-vg /dev/sdd1 /dev/sde1
vgcreate docs-vg /dev/sde2

# Creacion de LV en LVM
lvcreate -n backups -l 100%FREE backups-vg
lvcreate -n data1 -l 20%FREE data-vg
lvcreate -n data2 -l 80%FREE data-vg
lvcreate -n docs -l 100%FREE docs-vg

# Creacion de filesystems
mkfs.ext4 /dev/backups-vg/backups
mkfs.ext4 /dev/data-vg/data1
mkfs.ext4 /dev/data-vg/data2
mkfs.ext4 /dev/docs-vg/docs

# Creacion de directorios
mkdir -p /media/{backups,data1,data2,docs}

# Montaje de filesystems
cat >> /etc/fstab << EOF
/dev/backups-vg/backups /media/backups ext4 defaults 0 0
/dev/data-vg/data1 /media/data1 ext4 defaults 0 0
/dev/data-vg/data2 /media/data2 ext4 defaults 0 0
/dev/docs-vg/docs /media/docs ext4 defaults 0 0
EOF

mount -a
