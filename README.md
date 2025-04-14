# packetsquirrel-scripts

Payloads for a Packet Squirrel Mark II

![LAN Turtle](psm2.png "Packet Squirrel Mark II")

## Install

```
opkg update
opkg install unzip
cd /usb
wget https://github.com/shaunsund/packetsqurrel-scripts/archive/refs/heads/main.zip
unzip main.zip
cd packetsquirrel-scripts-main
./deploy
cd ..
rm main.zip
rm -rfv packetsquirrel-scripts-main
cd
```

## About Packet Squirrel Mark II

Offical Packet Squirrel ressources:
 [HAK5 Shop](https://hak5.org/products/packet-squirrel-mark-ii) | [Documentation](https://docs.hak5.org/packet-squirrel-mark-ii/) | [GitHub](https://github.com/hak5/packetsquirrel-payloads)
