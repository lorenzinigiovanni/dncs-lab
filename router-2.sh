export DEBIAN_FRONTEND=noninteractive

sysctl net.ipv4.ip_forward=1

ip addr add 192.168.3.130/30 dev enp0s9
ip addr add 192.168.3.1/25 dev enp0s8

ip link set enp0s9 up
ip link set enp0s8 up

ip route add default via 192.168.3.129
