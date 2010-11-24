#!/bin/bash
# Script to setup vnstats for the interfaces specified.

# Add more interfaces if you want here.
interfaces='eth0'

# Stuff that should stay constant in Gentoo. Change if needed.
dname='vnstatd'
runlevel='default'
user='vnstat'
vnstatDir='/var/lib/vnstat'

# Install the app if needed
emerge -u vnstat || exit 1

# Make sure our vnstat user exists
for file in passwd group; do
    grep "${user}" "/etc/${file}" &>/dev/null || exit 1
done

# Setup our interfaces if needed.
for int in ${interfaces}; do 
    # Create new DB and chown to vnstat user
    # if it's not there.
    dbFile="${vnstatDir}/${int}"
    if [ ! -s "${dbFile}" ]; then
        echo "Configuring vnstat with ${int}"
        vnstat -u -i ${int} || exit 1
        echo "Configured ${int} successfully."
    else
        echo "Skipping ${int} - already configured."
    fi
done

# Set the files to the correct permissions
if [ -d "${vnstatDir}" ]; then
    echo "Setting permissions on ${vnstatDir}"
    chown -R "${user}:${user}" ${vnstatDir} || exit 1
else
    echo "Cannot find ${vnstatDir}."
    exit 1
fi

# Start our service if needed.
serviceStart ${dname}

# Add to startup
addToStart ${dname}

# All done.
exit 0
