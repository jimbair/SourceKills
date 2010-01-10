#!/bin/bash
#
# srcds_bansync.sh
#
# Script to build a master banlist from all four gamservers.
# This is used to keep all of our gameservers syncronized 
# with the same banlist across all servers.
#
# This only builds the list! Another script is run to execute
# the list into each gameserver's console. So this is only part #1.
#
# v.2 - Re-written for the migration to the Xeon 3320.
#
# SourceKills.com
# Jim Bair
# 9/21/2008

# Variables
working=/tmp/srcds_working.tmp
prog=$(basename $0)
banlists='/home/srcds1/css1/cstrike/cfg/banned_user.cfg /home/srcds1/css1/cstrike/cfg/banned_ip.cfg /home/srcds2/css2/cstrike/cfg/banned_user.cfg /home/srcds2/css2/cstrike/cfg/banned_ip.cfg /home/srcds3/css3/cstrike/cfg/banned_user.cfg /home/srcds3/css3/cstrike/cfg/banned_ip.cfg /home/srcds4/css4/cstrike/cfg/banned_user.cfg /home/srcds4/css4/cstrike/cfg/banned_ip.cfg'
banlistid=$(echo $banlists | sed 's/\ /\n/g' | grep banned_user)
banlistip=$(echo $banlists | sed 's/\ /\n/g' | grep banned_ip)
fullid=/tmp/fullid.txt
fullip=/tmp/fullip.txt

# Send errors via echo to stderr
error() {
	echo $@ >&2
}

# Exits if given ctrl+c (interrupt) signal.
trap gtfo 2
gtfo() {
        echo "$prog caught SIGINT. Exiting"
	rm -f $working
	exit 1
}

# Must be ran as root
if [ $UID -ne 0 ]; then
	error 'This script must be ran as root due to permissions reasons.'
	error 'Exiting.'
	exit 1
fi

# Make sure our banlists exist!
for a in $banlists; do
	if [ ! -e $a ]; then
		error "ERROR: The banlist $a does not exist!"
		error 'Exiting.'
		exit 1
	fi
done

# Make sure we're not double syncing the madness.
if [ -e $working ]; then
	error "ERROR: $prog is currently running!"
	error 'Exiting.'
	exit 1
else
	echo -e "\nStarting $prog at `date`"
	echo -n 'Creating work file...'
	touch $working
	echo 'Done.'
fi

# Create our massive banlists (one for IDs, one for IPs).
# Create our banlist files
for b in $fullid $fullip; do
	if [ ! -e $b ]; then
		touch $b
	else
		# Throw a message to stdout if banlists currently exist.
		echo "WARNING: Our banlist file $b exists! This probably isn't a problem, but noting anyways."
		echo 'Sleeping for 10 seconds then clearing out our banlist. Use ctrl+c now if you want to stop this.'
		sleep 10
		rm -f $b
		touch $b
	fi
done

# Add our header to our ID banlist as we publish that.
echo -n 'Adding our header to the ID banlist...'
echo -e "// SourceKills.com Master Banlist\n// This list was automatically generated on `date`" >> $fullid
echo 'done!'

# Dump our server specific bans into our files
# SteamIDs
for c in $banlistid; do
	echo -n "Merging $c into $fullid..."
	cat $c >> $fullid
	echo 'Done.'
done

#IPs
for d in $banlistip; do
	echo -n "Merging $d into $fullip..."
	cat $d >> $fullip
	echo 'Done.'
done

# Get rid of duplicate entries and sort them for good measure. =)
for e in $fullid $fullip; do
	echo -n "Cleaning up ${e}..."
	sort -u -o ${e}.final $e
	mv ${e}.final $e
	chmod 644 $e
	echo 'Done.'
done

# Clean up our work file
if [ ! -e $working ]; then
	error 'ERROR: Our work file is missing!'
	error 'Either someone deleted it or something has gone awry. Please investigate.'
	error 'Exiting.'
	exit 1
else
	echo -n 'Removing our work file...'
	rm -f $working
	echo 'Done.'
fi

# We're done.
echo -e "\nSUCCESS: Master banlists build completed at `date`! You may now execute them in each srcds gameserver."
