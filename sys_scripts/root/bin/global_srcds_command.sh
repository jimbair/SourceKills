#!/bin/bash
# Script to save the banlists for all 4 gameservers. Used to prevent banlist loss.
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
globalWriteid() {
	
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
	globalScreen "$command"

	# Restore original permissions to the tty
	echo -n "[`date`] - Restoring permissions to $PERMS on ${TTY}..."
	chmod $PERMS $TTY
	echo 'done.'
}

# Timestamp our echos
echostamp() {
	echo -e "[$(date)] - $@"
}

##########
## MAIN ##
##########

command="$@"

# Must be run as root
if [ $UID -ne 0 ]; then
	echostamp "ERROR: This script must be run as root. Exiting." >&2
	exit 1
fi

# Run our function and exit
globalWriteid
exit 0
