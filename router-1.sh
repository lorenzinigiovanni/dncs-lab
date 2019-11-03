export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y isc-dhcp-server

echo -e 'INTERFACESv4="enp0s8.1"\nINTERFACESv6=""' > /etc/default/isc-dhcp-server
echo -e 'default-lease-time 600;\nmax-lease-time 7200;\nddns-update-style none;\nsubnet 192.168.1.0 netmask 255.255.255.0 {\n        range 192.168.1.2 192.168.1.254;\n        option subnet-mask 255.255.255.0;\n        option routers 192.168.1.1;\n}' > /etc/dhcp/dhcpd.conf

systemctl start isc-dhcp-server.service

sysctl net.ipv4.ip_forward=1

ip link add link enp0s8 name enp0s8.1 type vlan id 1
ip link add link enp0s8 name enp0s8.2 type vlan id 2

ip addr add 192.168.3.129/30 dev enp0s9
ip addr add 192.168.1.1/24 dev enp0s8.1
ip addr add 192.168.2.1/24 dev enp0s8.2

ip link set enp0s9 up
ip link set enp0s8 up

ip route add default via 192.168.3.130
