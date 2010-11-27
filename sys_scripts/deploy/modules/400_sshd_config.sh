#!/bin/bash
# This module tweaks the sshd config to our needs.
ourFile='/etc/ssh/sshd_config'
updated='false'
checkForFile ${ourFile} || exit 1

# If we don't have an SSH port, set it to the default
[ -z "${sshPort}" ] && sshPort=22

# See which way we need to patch our config
portType='dead'
livePort=$(egrep "^Port [0-9]" "${ourFile}" | awk '{print $2}')
if [ -n "${livePort}" ]; then
    portType='live'
fi

# Patch and restart sshd
echo "Patching our sshd config."
# Allow root logins with keys only
if [ "$(grep "#PermitRootLogin yes" "${ourFile}" )" ]; then
    echo "Patching PermitRootLogin"
    sed -i "s/#PermitRootLogin yes/PermitRootLogin without-password/" "${ourFile}"
    updated='true'
else
    echo "PermitRootLogin already patched - skipping."
fi

# Setup our sshd port
if [ "${portType}" == 'dead' ]; then
    echo "Appending port to ${ourFile}"
    echo "Port ${sshPort}" >> ${ourFile}
    updated='true'
elif [ "${portType}" == 'live' -a "${sshPort}" -ne "${livePort}" ]; then
    echo "Updating port on ${ourFile}"
    sed -i "s/Port ${livePort}/Port ${sshPort}/g" "${ourFile}"
    updated='true'
elif [ "${portType}" == 'live' -a "${sshPort}" -eq "${livePort}" ]; then
    echo "sshd already configured to port ${livePort} - skipping."
# If we get here, something is broken. We should never get here.
else
    echo "Something broke with our port configuration." >&2
    echo "portType ${portType}" >&2
    echo "livePort ${livePort}" >&2
    echo "sshPort ${sshPort}" >&2
    exit 1
fi

echo "Done patching our sshd config."

if [ "${updated}" == 'true' ]; then
    /etc/init.d/sshd restart || exit 1
else
   echo "Nothing changed - not restarting sshd."
fi

exit 0
