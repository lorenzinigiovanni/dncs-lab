export DEBIAN_FRONTEND=noninteractive

apt update
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update
apt install -y docker-ce

docker pull nginx

ip addr add 192.168.3.2/25 dev enp0s8

ip link set enp0s8 up

ip route add 192.168.0.0/16 via 192.168.3.1
