#!/bin/bash
# This module simply checks if srcds_linux is running

# Find the PID of our SourceDS server(s)
ourPIDs="$(pidof srcds_linux)"

# Exit accordingly.
if [ -n "${ourPIDs}" ]; then
    echo -n "status ok Found $(echo ${ourPIDs} | wc -w) SourceDS instances:"
    for i in ${ourPIDs}; do
        echo -n " ${i}"
    done
    echo ''
    # Print our PIDs as integer metrics. May be useful
    for i in ${ourPIDs}; do
        echo "metric srcds_linux_pid int ${i}"
    done
    exit 0
else
    echo "status warn No SourceDS instances found."
    exit 0
fi
