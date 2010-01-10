#!/bin/bash
# Script to check the status of our gameservers
for i in $(seq 4); do
	status=$(qstat -a2s css${i}.sourcekills.com:27015 | grep DOWN)
	if [ -z "$status" ]; then
		echo "SUCCESS: css${i}.sourcekills.com:27015 is online."
	else
		echo "ERROR: css${i}.sourcekills.com:27015 is OFFLINE." >&2
	fi
done
