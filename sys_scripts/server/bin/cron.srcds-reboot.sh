#!/bin/bash
# Script to reboot our CS:S Gameservers
# Written to work for all 4 servers
# jb@2008-12-28

cssdir=$(cd $HOME ; ls | grep css[0-9])
cssnum=$(echo $cssdir | wc -l)
lockFile="/tmp/.${cssdir}-update.lock"

log_message() {
	echo "[`date`] - $@"
}

leave() {
	rm -f $lockFile
	exit $1
}

# Check our variables
if [ -z "$cssdir" ]; then
	log_message "ERROR: Cannot find our css directory. Exiting." >&2
	exit 1
elif [ "$cssnum" -gt 1 ]; then
	log_message "ERROR: More than one css directory found. Exiting." >&2
	exit 1
# Check for lock file
elif [ -f $lockFile ]; then
	log_message "ERROR: $(basename $0) is already running. Exiting." >&2
	exit 1
fi

############
### MAIN ###
############
log_message "$(basename $0) has started."

# Lock out srcds-status.sh
touch $lockFile

# Update the gameserver
update=${HOME}/${cssdir}/update.sh
if [ -x $update ]; then
	log_message "Executing update script $update"
	$update
else
	log_message "ERROR: Cannot execute our update binary. Exiting." >&2
	leave 1
fi

# Reboot the gameserver
reboot=$HOME/bin/reboot
if [ -x $reboot ]; then
	log_message "Executing our reboot script $reboot"
	$reboot
	log_message "Reboot completed!"
	leave 0
else
	log_message "ERROR: Cannot find our reboot script. Exiting." >&2
	leave 1
fi
