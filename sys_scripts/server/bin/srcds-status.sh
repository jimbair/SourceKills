#!/bin/bash
# Script to poll the gameservers and reboot accordingly.
# Written to work for all 4 servers
# jb@2009-04-07
# v1.0 - Tested and Working

cssdir=$(cd $HOME ; ls | grep css[0-9])
cssnum=$(echo $cssdir | wc -l)
lockFile="/tmp/.${cssdir}-update.lock"

log_message() {
	echo "[$(date +%x) $(date +%X)] - $@"
}

# Check our variables
if [ -z "$cssdir" ]; then
	log_message "ERROR: Cannot find our css directory. Exiting." >&2
	exit 1
elif [ "$cssnum" -gt 1 ]; then
	log_message "ERROR: More than one css directory found. Exiting." >&2
	exit 1
# Make sure cron.srcds-update.sh isn't running
# Not technically an error.
elif [ -f $lockFile ]; then
	log_message "INFO: cron.srcds-update.sh is running. Exiting."
	exit 0
fi

log_message "$(basename $0) has started."

# Make sure qstat is installed
qstat --help > /dev/null 2>&1
if [ $? -eq 127 ]; then
	log_message "ERROR: qstat not installed. Exiting." >&2
	exit 1
fi
# If server is down, it will pass us DOWN in the output - $? is always 0 for qstat
serverStatus=$(qstat -a2s ${cssdir}.sourcekills.com:27015 | egrep 'DOWN|no response')
if [ -n "$serverStatus" ]; then
	log_message "Server is down! Rebooting."
	
	# Reboot the gameserver
	reboot=$HOME/bin/reboot
	if [ -x $reboot ]; then
		log_message "Executing our reboot script $reboot"
		$reboot
		log_message "Reboot completed!"
		exit 0
	else
		log_message "ERROR: Cannot find our reboot script. Exiting." >&2
		exit 1
	fi
	
	# Check if our server is back up
	# Sleep for a bit first, let it load up
	log_message "Pausing for 20 seconds."
	sleep 20
	serverStatus=$(qstat -a2s ${cssdir}.sourcekills.com:27015 | egrep 'DOWN|no response')
	# If we failed a second time, something is seriously broken.
	if [ -n "$serverStatus" ]; then
		log_message "ERROR: Server is STILL DOWN after a reboot. Please investigate! Exiting." >&2
		exit 1
	else
		log_message "Server is now back online."
		exit 0
	fi
else
	log_message "Server is up! Info:"
	qstat -a2s ${cssdir}.sourcekills.com:27015
	log_message "Exiting."
	exit 0
fi
