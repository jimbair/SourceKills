#!/bin/bash
# This module tweaks the sshd config to our needs.
ourFile='/etc/ssh/sshd_config'
checkForFile ${ourFile}

# If we don't have an SSH port, set it to the default
[ -z "${sshPort}" ] && sshPort=22

# See which way we need to patch our config
portType='dead'
livePort=$(egrep "^Port ${sshPort}" ${ourFile} | awk '{print $2}')
if [ -n "${livePort}" ]; then
    portType='alive'
fi

# Patch and restart sshd
echo "Patching our sshd config."
# Allow root logins with keys only
sed -i "s/#PermitRootLogin yes/PermitRootLogin without-password/" ${ourFile}
# Setup our sshd port
if [ "${portType}" == 'dead' ]; then
    echo "Port ${sshPort}" >> ${ourFile}
elif [ "${portType}" == 'live' -a "${sshPort}" != ${livePort} ]; then
    sed -i "s/Port ${livePort}/Port ${sshPort}/g"
elif [ "${portType}" == 'live' -a "${sshPort}" == ${livePort} ]; then
    echo "sshd already configured to port ${livePort}."
else
    echo "Something broke with our port configuration." >&2
    exit 1
fi
echo "Done patching our sshd config."

/etc/init.d/sshd restart || exit 1

exit 0
