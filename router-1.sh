export DEBIAN_FRONTEND=noninteractive

ip link add link enp0s8 name enp0s8.1 type vlan id 1
ip link add link enp0s8 name enp0s8.2 type vlan id 2

ip addr add 192.168.3.129/30 dev enp0s9
ip addr add 192.168.1.1/24 dev enp0s8.1
ip addr add 192.168.2.1/24 dev enp0s8.2

ip link set enp0s9 up
ip link set enp0s8 up
