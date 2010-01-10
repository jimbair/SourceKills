#!/bin/bash
# A simple script to clear out old content from
# the cstrike/downloads/ folder.
#
# Re-written for Maximus
# Jim Bair 10/4/2008 1.1

# Find files 7+ days old and delete them.
#
# find will error due to downloads/ being older than
# 7 days. Nothing to worry about. =)

# Starting out
echo "Starting $(basename $0) at `date`"

# Go into each server's downloads folder, and delete everything in it older than a week old.
for i in 1 2 3 4; do
	echo "Deleting files from /home/srcds${i}/css${i}/cstrike/downloads/ that are older than a week old..."
	find /home/srcds${i}/css${i}/cstrike/downloads/* -atime +7 -delete
	if [ $? -eq 0 ]; then
		# Make sure we exit gracefully.
		echo 'done!'
	else
		# If something goes wrong, stop the script.
		echo 'ERROR: Our find command failed. Please investigate. Exiting.' >&2
		exit 1
	fi
done

# All finished!
echo "SUCCESS: All directories cleared out on `date`"
exit 0
