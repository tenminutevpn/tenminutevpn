#!/bin/bash

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-wireguard.conf
sysctl --system

# Configure iptables
iptables -A INPUT -p udp --dport 51820 -j ACCEPT

# Find default interface
iface=$(ip route | grep default | awk '{print $5}')

# Configure WireGuard
cat <<EOF > {{ wireguard_server_config }}
[Interface]
PrivateKey = $(cat {{ wireguard_server_privatekey }})
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${iface} -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${iface} -j MASQUERADE

[Peer]
PublicKey = $(cat {{ wireguard_client_publickey }})
AllowedIps = 10.0.0.2/32
EOF

# Enable and start WireGuard
wg-quick up wg0
systemctl enable wg-quick@wg0

ipv4=$(curl https://api.ipify.org)

# Configure WireGuard client
cat <<EOF > {{ wireguard_client_config }}
[Interface]
PrivateKey = $(cat {{ wireguard_client_privatekey }})
Address = 10.0.0.2/32

[Peer]
PublicKey = $(cat {{ wireguard_server_publickey }})
Endpoint = $ipv4:51820
AllowedIps = 0.0.0.0/0
EOF
