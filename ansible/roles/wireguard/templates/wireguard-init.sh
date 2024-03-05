#!/bin/bash

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-wireguard.conf
sysctl --system

# Configure iptables
iptables -A INPUT -p udp --dport 51820 -j ACCEPT

# Configure WireGuard
cat <<EOF > {{ wireguard_server_config }}
[Interface]
PrivateKey = $(cat {{ wireguard_server_privatekey }})
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = $(cat {{ wireguard_client_publickey }})
AllowedIps = 10.0.0.2/32
EOF

# Enable and start WireGuard
wg-quick up wg0
systemctl enable wg-quick@wg0

# Configure WireGuard client
cat <<EOF > {{ wireguard_client_config }}
[Interface]
PrivateKey = $(cat {{ wireguard_client_privatekey }})
Address = 10.0.0.2/32

[Peer]
PublicKey = $(cat {{ wireguard_server_publickey }})
Endpoint = {{ wireguard_server_ipv4.content }}:51820
AllowedIps = 0.0.0.0/0
EOF
