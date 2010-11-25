#!/bin/bash
# Function to add a service to default start runlevel
removeFromStart() {

    service=$1
    runlevel='default'

    # Find our runlevel and add if needed
    currentRunlevel="$(rc-update -s | egrep "^[[:space:]]*${service}" | awk '{print $NF}')"
    if [ -n "${currentRunlevel}" ]; then
        echo "Removing ${service} service from ${runlevel} runlevel."
        rc-update del ${service} ${runlevel} || exit 1
    else
        echo "Service ${service} not set to ${currentRunlevel} runlevel."
    fi

}

export -f removeFromStart
