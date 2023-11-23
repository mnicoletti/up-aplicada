#!/bin/bash
SERV_HOSTNAME=$1

apt-get update -y
apt-get install -y git vim ntp ntpdate sudo

# Configuro el hostname
echo $SERV_HOSTNAME > /etc/hostname
hostname $SERV_HOSTNAME

# Agregar usuario caadmin a sudoers
echo "caadmin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configurar timezone
timedatectl set-timezone America/Argentina/Buenos_Aires