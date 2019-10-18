export DEBIAN_FRONTEND=noninteractive

ip addr add 192.168.3.130/30 dev enp0s9
ip addr add 192.168.3.1/25 dev enp0s8

ip link set enp0s9 up
ip link set enp0s8 up
