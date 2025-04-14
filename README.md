# packetsquirrel-scripts

Payloads for a Packet Squirrel Mark II

![LAN Turtle](psm2.png "Packet Squirrel Mark II")

## Install

```
opkg update
opkg install unzip
cd /usb
wget -O packetsquirrel-scripts.zip https://github.com/shaunsund/packetsquirrel-scripts/archive/refs/tags/0.0.2.zip
unzip packetsquirrel-scripts.zip
cd packetsquirrel-scripts-0.0.2
./deploy
cd ..
rm packetsquirrel-scripts.zip
rm -rfv packetsquirrel-scripts-0.0.2
cd
```

## About Packet Squirrel Mark II

Official Packet Squirrel resources:
 [HAK5 Shop](https://hak5.org/products/packet-squirrel-mark-ii) | [Documentation](https://docs.hak5.org/packet-squirrel-mark-ii/) | [GitHub](https://github.com/hak5/packetsquirrel-payloads)
