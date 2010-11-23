#!/bin/bash
# Find the status of a service using it's init script.

serviceStart() {
    service=$1
    status="$(serviceStatus $1)"
    if [ "${status}" != 'started' ]; then
        service ${service} start || exit 1
    else
        echo "Service '${service}' already started - skipping."
        exit 0
    fi
}

export serviceStart
