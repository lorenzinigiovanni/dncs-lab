export DEBIAN_FRONTEND=noninteractive

ip addr add 192.168.1.2/24 dev enp0s8

ip link set enp0s8 up

ip route add default via 192.168.1.1
