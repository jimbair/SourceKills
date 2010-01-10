#!/bin/bash
# Script to remove bans globally from all 4 gameservers.
#
# v1.0 - Working script - Finalized.

# Function used to remove bans by talking to a tty screen session.
# Work-around since screen -X with multiuser sessions doesn't work.
# Props to Keith Geffert on this one (March 19th, 2009).
banRemove() {

	# Variables!
	userName=$1
	screenName=$2
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
	
	# Remove our ban
	echostamp "Running removeid $SteamID on ${userName}/${screenName}."
	su -l $userName -c "screen -p 0 -S $screenName -X stuff \"removeid $SteamID\""
	echostamp "Running writeid on ${userName}/${screenName}."
	su -l $userName -c "screen -p 0 -S $screenName -X stuff \"writeid\""

	# Restore original permissions to the tty
	echo -n "[`date`] - Restoring permissions to $PERMS on ${TTY}..."
	chmod $PERMS $TTY
	echo 'done.'
}

# Timestamp our echos
echostamp() {
	echo -e "[`date`] - $@"
}

# Usage
usage() {
	echostamp "ERROR: $(basename $0) usage: <STEAM_ID>"
}

##########
## MAIN ##
##########

# Must be run as root
if [ $UID -ne 0 ]; then
	echostamp "ERROR: This script must be run as root. Exiting." >&2
	exit 1
fi

# We need 1 argument (SteamID to unban)
if [ $# -ne 1 ]; then
	usage >&2
	exit 1
fi

# Verify we got a legit SteamID
# First we verify the 1st part and uppercase any lowers.
SteamID=$(echo $1 | tr [a-z] [A-Z] | egrep '^STEAM_0:[0-1]:[0-9]')
if [ -z "$SteamID" ]; then
	usage >&2
	exit 1
else
	# Make sure there are no letters in the last part of the ID.	
	lastCheck=$(echo $SteamID | cut -d : -f 3- | sed '/[^0-9]/d')
	if [ -z "$lastCheck" ]; then
		usage >&2
		exit 1
	fi
fi

# Remove the bans!
for i in 1 2 3 4; do
	echostamp "Attempting to run banRemove() for $SteamID on srcds${i}/css${i}."
	banRemove "srcds${i}" "css${i}"
	if [ $? -ne 0 ]; then
		echostamp "ERROR: Running banRemove() for $SteamID on srcds${i}/css${i} failed. Exiting."
		exit 1
	else
		echostamp "SUCCESS! Ran banRemove() for $SteamID on srcds${i}/css${i} successfully."
		echo
	fi
done

# All done
echostamp "SUCCESS: $SteamID has been removed globally from all banlists."
exit 0
