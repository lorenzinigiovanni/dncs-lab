# DNCS-LAB

**Author:** Lorenzini Giovanni  
**Student number:** 193473

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.

# Network topology

```

        +-----------------------------------------------------+
        |                                                     |
        |                                                     |enp0s3
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |          enp0s3|            |enp0s9 enp0s9|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |enp0s8                     |enp0s8
        |  N  |                      |                           |
        |  A  |                      |                           |enp0s8
        |  G  |                      |                     +-----+----+
        |  E  |                      |enp0s8               |          |
        |  M  |            +-------------------+           |          |
        |  E  |      enp0s3|                   |           |  host-c  |
        |  N  +------------+      switch       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |enp0s9       |enp0s10             |enp0s3
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |enp0s8       |enp0s8              |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |  enp0s3|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |enp0s3                 |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+

```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
```
~$ git clone https://github.com/lorenzinigiovanni/dncs-lab
```
 - You should be able to launch the lab from within the cloned repo folder
```
~$ cd dncs-lab
~/dncs-lab$ vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 6 VMs
 ```
~/dncs-lab$ vagrant status                                                                                                                                                                
Current machine states:

router-1                  running (virtualbox)
router-2                  running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
host-c                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
```
~/dncs-lab$ vagrant ssh router-1
~/dncs-lab$ vagrant ssh router-2
~/dncs-lab$ vagrant ssh switch
~/dncs-lab$ vagrant ssh host-a
~/dncs-lab$ vagrant ssh host-b
~/dncs-lab$ vagrant ssh host-c
```

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of 

## Design Requirements
- **host-a** and **host-b** are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 175 and 213 usable addresses
- **host-c** is in a subnet (*Hub*) that needs to accommodate up to 118 usable addresses
- **host-c** must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from **host-a** and **host-b**
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

## Subnets

| Subnet | Subnet address | Prefix | Usable addresses  | Devices |
| :---: |  :---: | :---: | :---: | :---: |
| Hosts-A | 192.168.1.0 | /24 | 254 | host-a (enp0s8)<br>router-1 (enp0s8.1) |
| Hosts-B | 192.168.2.0 | /24 | 254 | host-b (enp0s8)<br>router-1 (enp0s8.2) |
| Hub | 192.168.3.0 | /25 | 126 | host-c (enp0s8)<br>router-2 (enp0s8) |
| D | 192.168.3.128 | /30 | 2 | router-1 (enp0s9)<br>router-2 (enp0s9) |

## VLANs

| Subnet | VLAN ID | Switch interface | Router interface |
| :---: |  :---: | :---: | :---: |
| Hosts-A | 1 | enp0s9 | enp0s8.1 |
| Hosts-B | 2 | enp0s10 | enp0s8.2 |

## Switch Ports

| Interface | Interface type | VLAN ID |
| :---: |  :---: | :---: |
| enp0s8 | Trunk | - |
| enp0s9 | Access | 1 |
| enp0s10 | Access | 2 | 

## IP Addresses

| Device | Interface | Subnet | IP | Prefix | 
| :---: |  :---: | :---: | :---: | :---: |
| host-a | enp0s8 | Hosts-A | DHCP | /24 |
| host-b | enp0s8 | Hosts-B | 192.168.2.2 | /24 |
| host-c | enp0s8 | Hub | 192.168.3.2 | /25 |
| router-1 | enp0s8.1 | Hosts-A | 192.168.1.1 | /24 |
| router-1 | enp0s8.2 | Hosts-B | 192.168.2.1 | /24 |
| router-1 | enp0s9 | D | 192.168.3.129 | /30 |
| router-2 | enp0s8 | Hub | 192.168.3.1 | /25 |
| router-2 | enp0s9 | D | 192.168.3.130 | /30 |

## Routing Tables

### host-a routing table

| Destination | Prefix | Gateway | Interface |
| :---: |  :---: | :---: | :---: |
| default | - | 192.168.1.1 | enp0s8 |
| 192.168.1.0 | /24 | - | enp0s8 |

### host-b routing table

| Destination | Prefix | Gateway | Interface |
| :---: |  :---: | :---: | :---: |
| default | - | 192.168.2.1 | enp0s8 |
| 192.168.2.0 | /24 | - | enp0s8 |

### host-c routing table

| Destination | Prefix | Gateway | Interface |
| :---: |  :---: | :---: | :---: |
| default | - | 192.168.3.1 | enp0s8 |
| 192.168.3.0 | /25 | - | enp0s8 |

### router-1 routing table

| Destination | Prefix | Gateway | Interface |
| :---: |  :---: | :---: | :---: |
| default | - | 192.168.3.130 | enp0s9 |
| 192.168.1.0 | /24 | - | enp0s8.1 |
| 192.168.2.0 | /24 | - | enp0s8.2 |
| 192.168.3.128 | /30 | - | enp0s9 |

### router-2 routing table

| Destination | Prefix | Gateway | Interface |
| :---: |  :---: | :---: | :---: |
| default | - | 192.168.3.129 | enp0s9 |
| 192.168.3.0 | /25 | - | enp0s8 |
| 192.168.3.128 | /30 | - | enp0s9 |

# Provisioning Shell Scripts

Each machine execute a dedicated script at provisioning. The scripts assign IPs, set routes and other things.

## host-a provisioning shell script

Enable the link
```
$ ip link set enp0s8 up
```

Get a DHCP address for interface enp0s8
```
$ dhclient enp0s8
```

## host-b provisioning shell script

Assign an IP address of Hosts-B subnet
```
$ ip addr add 192.168.2.2/24 dev enp0s8
```

Enable the link
```
$ ip link set enp0s8 up
```

Add default route to accede to the network
```
$ ip route add default via 192.168.2.1
```

## host-c provisioning shell script

Install docker
```
$ apt update
$ apt install apt-transport-https ca-certificates curl software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
$ add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
$ apt update
$ apt install -y docker-ce
```

Download nginx docker image
```
$ docker pull dustnic82/nginx-test
```

Create a html file to serve
```
$ mkdir /www
$ echo -e '<!DOCTYPE html>\n<html>\n<head>\n    <meta charset="UTF-8">\n    <title>DNCS LAB</title>\n</head>\n<body>\n    <h1>DNCS LAB</h1>\n    <h3>Author: Lorenzini Giovanni</h3>\n    <h3>Student number: 193473</h3>\n</body>\n</html>' > /www/index.html
```

Run the nginx docker container
```
$ docker run --name nginx -v /www:/usr/share/nginx/html -d -p 80:80 dustnic82/nginx-test
```

Assign an IP address of Hub subnet
```
$ ip addr add 192.168.3.2/25 dev enp0s8
```

Enable the link
```
$ ip link set enp0s8 up
```

Add default route to accede to the network
```
$ ip route add default via 192.168.3.1
```

## switch provisioning shell script

Install Open vSwitch
```
$ apt-get update
$ apt-get install -y tcpdump
$ apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
```

Create a bridge in the switch
```
$ ovs-vsctl add-br br0
```

Bind the trunk interface to the bridge
```
$ ovs-vsctl add-port br0 enp0s8
```

Bind the access interfaces to the bridge
```
$ ovs-vsctl add-port br0 enp0s9 tag=1
$ ovs-vsctl add-port br0 enp0s10 tag=2
```

Enable the links
```
$ ip link set enp0s8 up
$ ip link set enp0s9 up
$ ip link set enp0s10 up
```

## router-1 provisioning shell script

Install ISC DHCP Server
```
apt update
apt install -y isc-dhcp-server
```

Create DHCP configuration files
```
echo -e 'INTERFACESv4="enp0s8.1"\nINTERFACESv6=""' > /etc/default/isc-dhcp-server
echo -e 'default-lease-time 600;\nmax-lease-time 7200;\nddns-update-style none;\nsubnet 192.168.1.0 netmask 255.255.255.0 {\n        range 192.168.1.2 192.168.1.254;\n        option subnet-mask 255.255.255.0;\n        option routers 192.168.1.1;\n}' > /etc/dhcp/dhcpd.conf
```

Start DHCP server service
```
systemctl start isc-dhcp-server.service
```

Enable IP forwarding
```
$ sysctl net.ipv4.ip_forward=1
```

Create VLAN interfaces to receive and send over the trunk link
```
$ ip link add link enp0s8 name enp0s8.1 type vlan id 1
$ ip link add link enp0s8 name enp0s8.2 type vlan id 2
```

Assign IP addresses of the right subnet to the interfaces 
```
$ ip addr add 192.168.3.129/30 dev enp0s9
$ ip addr add 192.168.1.1/24 dev enp0s8.1
$ ip addr add 192.168.2.1/24 dev enp0s8.2
```

Enable the links
```
$ ip link set enp0s9 up
$ ip link set enp0s8 up
```

Add default route to other router
```
$ ip route add default via 192.168.3.130
```

## router-2 provisioning shell script

Enable IP forwarding
```
$ sysctl net.ipv4.ip_forward=1
```

Assign IP addresses of the right subnet to the interfaces 
```
$ ip addr add 192.168.3.130/30 dev enp0s9
$ ip addr add 192.168.3.1/25 dev enp0s8
```

Enable the links
```
$ ip link set enp0s9 up
$ ip link set enp0s8 up
```

Add default route to other router
```
$ ip route add default via 192.168.3.129
```

# How to Test

## Run the project

Clone the repository, create and configure the VMs
```
~$ git clone https://github.com/lorenzinigiovanni/dncs-lab
~$ cd dncs-lab
~/dncs-lab$ vagrant up
```

## switch test

### SSH in switch
```
~/dncs-lab$ vagrant ssh switch
```

### View the switching table
```
vagrant@switch:~$ sudo ovs-appctl fdb/show br0
 port  VLAN  MAC                Age
    1     1  08:00:27:ab:11:e5   17
    2     1  08:00:27:73:ef:5a   17
    3     2  08:00:27:80:0e:b9    1
    1     2  08:00:27:ab:11:e5    1
```
- The first record is router-1 on port 1 and VLAN 1
- The second record is host-a on port 2 and VLAN 1
- The third record is host-b on port 3 and VLAN 2
- The fourth record is router-1 on port 1 and VLAN 2

## router-1 and router-2 test

### SSH in router-1 or router-2
```
~/dncs-lab$ vagrant ssh router-1
~/dncs-lab$ vagrant ssh router-2
```

### View the routing table
```
vagrant@router-1:~$ ip r show
default via 192.168.3.130 dev enp0s9 
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100 
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100
192.168.1.0/24 dev enp0s8.1 proto kernel scope link src 192.168.1.1
192.168.2.0/24 dev enp0s8.2 proto kernel scope link src 192.168.2.1
192.168.3.128/30 dev enp0s9 proto kernel scope link src 192.168.3.129
```

## host-c test

### SSH in host-c
```
~/dncs-lab$ vagrant ssh host-c
```

### Check if docker container is running
```
vagrant@host-c:~$ sudo docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                         NAMES
3ab2d86214b3        dustnic82/nginx-test   "nginx -g 'daemon of…"   4 hours ago         Up 4 hours          0.0.0.0:80->80/tcp, 443/tcp   nginx
```

## host-a and host-b test

### SSH in host-a or host-b
```
~/dncs-lab$ vagrant ssh host-a
~/dncs-lab$ vagrant ssh host-b
```

### Ping host-c
```
vagrant@host-a:~$ ping 192.168.3.2
PING 192.168.3.2 (192.168.3.2) 56(84) bytes of data.
64 bytes from 192.168.3.2: icmp_seq=1 ttl=62 time=0.828 ms
64 bytes from 192.168.3.2: icmp_seq=2 ttl=62 time=0.615 ms
^C
--- 192.168.3.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.615/0.721/0.828/0.109 ms
```
host-c is reachable by host-a

### Tracepath host-c
```
vagrant@host-a:~$ tracepath 192.168.3.2
 1?: [LOCALHOST]                      pmtu 1500
 1:  _gateway                                              0.470ms 
 1:  _gateway                                              0.347ms
 2:  192.168.3.130                                         0.496ms 
 3:  192.168.3.2                                           0.612ms reached
     Resume: pmtu 1500 hops 3 back 3
```
To reach host-c (192.168.3.2) the packet travel through router-1 (gateway) and router-2 (192.168.3.130)

### Get the index html page from the webserver hosted on host-c
```
vagrant@host-a:~$ curl 192.168.3.2
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DNCS LAB</title>
</head>
<body>
    <h1>DNCS LAB</h1>
    <h3>Author: Lorenzini Giovanni</h3>
    <h3>Student number: 193473</h3>
</body>
</html>
```
