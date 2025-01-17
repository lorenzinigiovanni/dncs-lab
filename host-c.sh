export DEBIAN_FRONTEND=noninteractive

apt update
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update
apt install -y docker-ce

docker pull dustnic82/nginx-test

mkdir /www
echo -e '<!DOCTYPE html>\n<html>\n<head>\n    <meta charset="UTF-8">\n    <title>DNCS LAB</title>\n</head>\n<body>\n    <h1>DNCS LAB</h1>\n    <h3>Author: Lorenzini Giovanni</h3>\n    <h3>Student number: 193473</h3>\n</body>\n</html>' > /www/index.html

docker run --name nginx -v /www:/usr/share/nginx/html -d -p 80:80 dustnic82/nginx-test

ip addr add 192.168.3.2/25 dev enp0s8

ip link set enp0s8 up

ip route add default via 192.168.3.1
