#!/bin/bash
INTERNAL_IF="enp0s8"
EXTERNAL_IF="enp0s3"

# Libero las reglas por posible re-ejecucion
iptables -F
iptables -X
iptables -Z

# Por defecto todo es DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Permito trafico local
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permito SSH a la red de IT
iptables -A INPUT -p tcp -s 192.168.10.163/32,192.168.10.164/32 --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp -d 192.168.10.163/32,192.168.10.164/32 --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Permito salida local de internet
iptables -A OUTPUT -o ${EXTERNAL_IF} -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -o ${EXTERNAL_IF} -p tcp --dport 443 -j ACCEPT

iptables -A OUTPUT -o lo -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -o lo -p tcp --dport 53 -j ACCEPT

## Salida a internet de la LAN interna
iptables -t nat -A POSTROUTING -s 192.168.10.160/27 -d 0.0.0.0/0 -j MASQUERADE
iptables -A FORWARD -s 192.168.10.160/27 -d 0.0.0.0/0 -i ${INTERNAL_IF} -o ${EXTERNAL_IF} -j ACCEPT
iptables -A FORWARD -d 192.168.10.160/27 -s 0.0.0.0/0 -i ${EXTERNAL_IF} -o ${INTERNAL_IF} -j ACCEPT