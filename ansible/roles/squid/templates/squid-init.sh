#!/bin/bash

cat <<EOF > /etc/squid/squid.conf
http_port 3128
http_access allow all
EOF

systemctl enable squid
systemctl start squid
