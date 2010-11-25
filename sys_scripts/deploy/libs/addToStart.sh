#!/bin/bash
# Function to add a service to default start runlevel
addToStart() {

    service=$1
    runlevel='default'

    # Find our runlevel and add if needed
    currentRunlevel="$(rc-update -s | egrep "^[[:space:]]*${service}" | awk '{print $NF}')"
    if [ "${currentRunlevel}" != "${runlevel}" ]; then
        echo "Adding ${service} service to ${runlevel} runlevel."
        rc-update add ${service} ${runlevel} || exit 1
    else
        echo "Service ${service} already set to ${currentRunlevel} runlevel."
    fi

}

export -f addToStart
