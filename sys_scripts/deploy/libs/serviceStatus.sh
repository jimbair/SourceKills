#!/bin/bash
# Find the status of a service using it's init script.

serviceStatus() {
    service=$1

    # Pull out the status - ensure it's not empty.
    status="$(service ${service} status | awk '{print $NF}')"
    if [ -z "${status}" ]; then
        echo "Unable to find status for service '${service}'" >&2
        exit 1
    fi

    # All done
    echo "${status}"
}

export -f serviceStatus
