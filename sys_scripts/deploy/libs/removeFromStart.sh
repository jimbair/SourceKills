#!/bin/bash
# Function to add a service to default start runlevel
removeFromStart() {

    service=$1
    runlevel='default'

    # Find our runlevel and add if needed
    currentRunlevel="$(rc-update -s | egrep "^[[:space:]]*${service}" | awk '{print $NF}')"
    if [ "${currentRunlevel}" == "${runlevel}" ]; then
        echo "Removing ${service} service from ${runlevel} runlevel."
        rc-update del ${service} ${runlevel} || exit 1
    elif [ -z "${currentRunlevel}" ]; then
        echo "Service ${service} not set to any runlevel - skipping"
    else
        echo "Unexpected result - please debug." >&2
        echo "service: ${service}" >&2
        echo "current runlevel: ${currentRunlevel}" >&2
        echo "expected runlevel: ${runlevel}" >&2
        exit 1
    fi

}

export -f removeFromStart
