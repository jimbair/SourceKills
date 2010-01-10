#!/bin/bash
# Script to fix affinity of our SourceDS processes.

# Finds the PID for the user's gameserver.
# Pass it the username as $1
findpid() {
	if [ -n "$1" ] && [ -z "$2" ]; then
		ps au | grep './srcds_i686' | grep $1 | grep -v grep | awk '{print $2}'
	else
		echo "findpid() was passed without proper args. Exiting."
		exit 1
	fi
}

# Find our PIDs
pid1=$(findpid srcds1)
pid2=$(findpid srcds2)
pid3=$(findpid srcds3)
pid4=$(findpid srcds4)

# Fix our affinity
taskset -cp 0 $pid1
taskset -cp 1 $pid2
taskset -cp 2 $pid3
taskset -cp 3 $pid4

echo 'SUCCESS: All PIDs assigned to their correct affinity.'
exit 0
