#!/bin/bash
# Library to wrap /etc/init.d/ similar to RHEL

service(){
    
    service=$1
    option=$2
    
    initFolder='/etc/init.d/'
    initScript="${initFolder}${service}"

    # Make sure the script is there and we can execute it.
    if [ ! -s "${initScript}" -o ! -x "${initScript}" ]; then
        echo "Init script for '${service}' missing or invalid." >&2
        exit 1
    fi

    # Run our init script.
    ${initScript} ${option}
}

export service
