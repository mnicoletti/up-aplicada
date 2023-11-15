#!/bin/bash
# Por defecto todo es DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Permito trafico local
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permito salida local de internet
iptables -A OUTPUT -o ens0p3 -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -o ens0p3 -p tcp --dport 443 -j ACCEPT

iptables -A OUTPUT -o lo -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -o lo -p tcp --dport 53 -j ACCEPT