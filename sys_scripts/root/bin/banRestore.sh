#!/bin/bash
#
# Script to back up our banlists since 
# VALVe likes to break these often.
#
# v2.0 - Complete re-write for Maximus
#      - Fixed a ton of bad code in the old ver.
#
# Jim Bair 10/4/2008

# Must be root for this script
if [ $UID -ne 0 ]; then
	echo 'You must be root to run this script. Exiting.' >&2
	exit 1
fi

# Add timestamps
log_message() {
	echo "[`date`] - $@"
}

# Our backup file
#backup=/root/banlists/backup.txt
backup=/home/tsuehpsyde/banned_user.cfg

# Make sure our file exists
if [ ! -e $backup ]; then
	log_message "Our backup file $backup is missing." >&2
	log_message "As this should always be present, we're exiting now. Please see what's going on." >&2
	exit 3
fi

# Read from our banlists and append to our master backup list
for i in 1 2 3 4; do
	cp $backup /home/srcds${i}/css${i}/cstrike/cfg/banned_user.cfg
	chown srcds${i}.srcds${i} /home/srcds${i}/css${i}/cstrike/cfg/banned_user.cfg
done
exit 0
