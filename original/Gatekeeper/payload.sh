#!/bin/bash

# Title:        Gatekeeper
#
# Description:  Toggle access to the network with the pushbutton

# Set the default network mode (such as NAT or BRIDGE)
NETWORK_MODE="BRIDGE"

NETMODE ${NETWORK_MODE}

LED G SOLID

while true; do
    # Run the buttom command with no LED; this way the LED stays
    # solid green
    NO_LED=1 BUTTON

    # Check the existing network mode; if we're not the right mode,
    # send the target device to jail
    if [ $(cat /tmp/squirrel_netmode) == "${NETWORK_MODE}" ]; then
        LED R FAST
        NETMODE JAIL
        LED R SOLID
    else
        # Set the network mode back to our normal mode
        LED G FAST
        NETMODE ${NETWORK_MODE}
        LED G SOLID
    fi
done
