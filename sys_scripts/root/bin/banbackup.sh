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
backup=/root/banlists/backup.txt

# Make sure our commands exit gracefully
exitcheck() {
	ec=$(echo $?)
	if [ $ec -ne 0 ]; then
		log_message "Exit code of $ec found. Exiting." >&2
		rm -f ${backup}.tmp ${backup}.orig
		exit 2
	fi
}

# Make sure our file exists
if [ ! -e $backup ]; then
	log_message "Our backup file $backup is missing." >&2
	log_message "As this should always be present, we're exiting now. Please see what's going on." >&2
	exit 3
fi

# Used to make sure list is the same or bigger later. use cat to remove filename stuff.
cp $backup ${backup}.orig
oldsize=$(cat $backup | wc -l)

# Read from our banlists and append to our master backup list
for i in 1 2 3 4; do
	cat /home/srcds${i}/css${i}/cstrike/cfg/banned_user.cfg >> $backup
	exitcheck
	cat /home/srcds${i}/css${i}/cstrike/cfg/banned_ip.cfg >> $backup
	exitcheck
done

# Remove duplicates and sort
sort -u $backup > ${backup}.tmp
exitcheck
cat ${backup}.tmp > $backup
exitcheck
rm -f ${backup}.tmp
exitcheck

# Make sure our list is the same size or bigger
newsize=$(cat $backup | wc -l)
if [ $newsize -ge $oldsize ]; then
	log_message 'SUCCESS: Banlists backed up successfully.'
	rm ${backup}.orig
	exit 0
else
	log_message 'ERROR: Our new banlist backup is smaller than the original. Something has gone wrong. Exiting.'
	mv ${backup}.orig $backup
	exit 4
fi
