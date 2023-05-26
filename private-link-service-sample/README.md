# PLS consumer-producer demo

https://github.com/Azure-Samples/azure-private-link-service/blob/main/images/architecture.png

## Server Echo
```bash
apt install ncat

ncat -l 11112 --keep-open --exec "/bin/cat" &
ncat -l 11112 --keep-open --udp --exec "/bin/cat" &

tcpdump -n port 11112
```

## Client
```bash
apt install telnet ncat

# TCP client (to Private Endpoint IP)
telnet 10.50.1.4 11112

# UDP client (to Private Endpoint IP)
ncat -u 10.50.1.4 11112
```
