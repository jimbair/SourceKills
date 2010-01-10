#!/bin/bash
# Script to shutdown all 4 gameservers. Used for kernel upgrades mainly.
#
# v1.0 - Working script - Finalized.

# Function to run commands in all screens
globalScreen() {
	for i in 1 2 3 4; do
		command="$@"
		echostamp "Running $command on srcds${i}/css${i}."
		su -l srcds${i} -c "screen -p 0 -S css${i} -X stuff \"$command\""
	done
}

# Main work is done here. Shuts down all 4 servers.
globalShutdown() {
	# Pause just in case.
	echostamp "Pausing for 5 seconds. If you do not wish to shutdown all gameservers, exit now."
	sleep 5
	
	# Hack to attach to all screens
	TTY=$(/usr/bin/tty)
	PERMS=$(/usr/bin/stat -c "%a" $TTY)
	
	# Make sure we got proper info back
	if [ $? -ne 0 ]; then
		echostamp "ERROR: Unable to find our TTY session. Exiting." >&2
		
	# Check that we got something back in the variable
	# Should probably use sed/grep to validate this a bit.
	elif [ -z "$PERMS" ]; then
		echostamp "ERROR: stat returned nothing! Exiting." >&2
	fi

	# First we need to set the perms for the tty so the su'd user
	# can write to this tty
	echo -n "[`date`] - Running chmod a+rw ${TTY}..."
	chmod a+rw $TTY
	echo 'done.'
	
	# Shutdown our gameservers.
	# Written to shut them down in order and not all @ once.
	# Figure this will be a bit more graceful to the system.
	globalScreen "say This server is shutting down in 1 minute for system upgrades. We will be back shortly!"
	sleep 60
	globalScreen "writeid"
	sleep 10
	globalScreen "exit"

	# Restore original permissions to the tty
	echo -n "[`date`] - Restoring permissions to $PERMS on ${TTY}..."
	chmod $PERMS $TTY
	echo 'done.'
}

# Timestamp our echos
echostamp() {
	echo -e "[$(date)] - $@"
}

# Usage
usage() {
	echostamp "ERROR: $(basename $0) usage: -y to confirm global SourceDS shutdown"
}

##########
## MAIN ##
##########

# Must be run as root
if [ $UID -ne 0 ]; then
	echostamp "ERROR: This script must be run as root. Exiting." >&2
	exit 1
fi

# We need 1 argument (Verify we want to shutdown)
if [ $# -ne 1 ]; then
	usage >&2
	exit 1
fi

# Must be run with -y to avoid accidental shutdown.
case $1 in 
	-y)
	globalShutdown
	exit 0
	;;

	*)
	usage >&2
	exit 1
	;;

esac
