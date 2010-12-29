#!/bin/bash
# Simple script to bring our SourceDS servers to nice -19.
#
# This can be done via sudo for each user, but it's better to just
# do this from here. Also, note that each process needs it's own
# processor, or this will cause all sorts of bustication.
#
# For reference, when setting affinity:
# 00 = CPU1, 01 = CPU2, 02 = CPU3, and 03 = CPU4. FYI.

# Must be root.
if [ $UID -ne 0 ]; then
	echo 'ERROR: You must be root to run this script. Exiting.' >&2
	exit 1
fi

# Find our pids
pid=$(pidof srcds_linux)
if [ -z "$pid" ]; then
    echo "Unable to find our SourceDS pids." >&2
    exit 1
fi

# Make sure we exited cleanly.
sudo renice -19 $pid
if [ $? -eq 0 ]; then
	echo 'SUCCESS! All SourceDS processes set to a nice of -19.'
	exit 0
else
	echo 'ERROR: Something has broken. Please investigate. Exiting.' >&2
	exit 2
fi
