#!/bin/bash
# Script to setup vnstats for the interfaces specified.

# Add more interfaces if you want here.
interfaces='eth0'
user='vnstat'
vnstatDir='/var/lib/vnstat'

# Install the app if needed
emerge -u vnstat || exit 1

# Make sure our vnstat user exists
for file in passwd group; do
    grep "${user}" "/etc/${file}" &>/dev/null || exit 1
done

for int in ${interfaces}; do 
    # Create new DB and chown to vnstat user
    # if it's not there.
    dbFile="${vnstatDir}/${int}"
    if [ ! -s "${dbFile}" ]; then
        echo "Configuring vnstat with ${int}"
        vnstat -u -i ${int} || exit 1
        chown -R "${user}:${user}" /var/lib/vnstat || exit 1
        echo "Configured ${int} successfully."
    else
        echo "Skipping ${int} - already configured."
    fi
done

# Start it up and set to startup
/etc/init.d/vnstatd start || exit 1
rc-update add vnstatd default || exit 1

exit 0
