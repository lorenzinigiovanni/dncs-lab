export DEBIAN_FRONTEND=noninteractive

ip addr add 192.168.3.2/25 dev enp0s8

ip link set enp0s8 up

ip route add 192.168.0.0/16 via 192.168.3.1
