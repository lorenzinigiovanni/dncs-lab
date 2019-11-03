export DEBIAN_FRONTEND=noninteractive

ip link set enp0s8 up

dhclient enp0s8
