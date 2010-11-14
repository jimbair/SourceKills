#!/bin/bash
# Script to setup vnstats for eth0

# Install the app
emerge vnstat || exit 1

# Create new DB and chown to vnstat user
vnstat -u -i eth0
chown -R vnstat:vnstat /var/lib/vnstat

# Start it up and set to startup
/etc/init.d/vnstatd start || exit 1
rc-update add vnstatd default || exit 1

exit 0
