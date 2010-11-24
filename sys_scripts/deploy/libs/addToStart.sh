#!/bin/bash
# Function to add a service to default start runlevel
addToStart() {

    service=$1
    runlevel='default'

    # Find our runlevel and add if needed
    currentRunlevel="$(rc-update -s | egrep "^[[:space:]]*${service}" | awk '{print $NF}')"
    if [ "${currentRunlevel}" != "${runlevel}" ]; then
        echo "Setting runlevel for ${service} to ${runlevel}."
        rc-update add ${service} ${runlevel} || exit 1
    else
        echo "Runlevel for ${service} already set to ${currentRunlevel}."
    fi

}

export addToStart
