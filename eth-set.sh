ip link set eth up
ip address add 192.168.1.2/24 broadcast + dev eth
ip route add 192.168.1.0/24 dev eth
ip route add default via 192.168.1.1 dev eth
