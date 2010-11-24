#!/bin/bash
# This is a script to quickly get Gentoo 10.1 64-bit 
# up and running after deployment of a slice.
# It runs the modules in order, numerically, and 
# configures the system for use according to the modules.
#
# Designed for SourceKills and Slicehost

PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
export PATH

# Arch vars
arch='x86_64'
systemArch="$(uname -m)"

# Module vars
modDir="$(dirname $0)/modules/"
modExt='.sh'
ourMods="$(ls ${modDir}*${modExt} | sort)"

# Library vars
libDir="$(dirname $0)/libs/"
libExt="${modExt}"
ourLibs="$(ls ${libDir}*${libExt} | sort)"

# Make sure we are root and in Gentoo
if [ "${UID}" -ne 0 ]; then
    echo "This script must be run as root." >&2
    exit 1
elif [ ! -s '/etc/gentoo-release' ]; then
    echo "This is not a Gentoo system." >&2
    exit 1
# We expect a 64-bit system
elif [ "${systemArch}" != "${arch}" ]; then
    echo "This is supposed to be an ${arch} platform." >&2
    exit 1
# Make sure we have some modules
elif [ ! -d "${modDir}" -o -z "${ourMods}" ]; then
    echo "No modules found to source!" >&2
    exit 1
# Make sure we have libraries too
elif [ ! -d "${libDir}" -o -z "${ourLibs}" ]; then
    echo "No libraries found to source!" >&2
    exit 1
fi

# Begin questions
while [ -z "${sshPort}" ]; do
    read -p "What port would you like SSH to run on: " sshPort
    # Remove our value if it's not a number
    sshPort="$(echo "${sshPort}" | sed '/[^0-9]/d')"
done

# Pass our question data over to the modules
export sshPort

# Start
echo "Deployment started at $(date)."

# Import our libraries
for lib in ${ourLibs}; do
    echo -n "Sourcing ${lib}..."
    source "${lib}" || exit 1
    echo 'done.'
done

# Start running each module
# Exit on any failures.
for i in ${ourMods}; do
    mod="$(basename ${i})"
    echo -e "\n${mod} -- Beginning work.\n"
    bash ${i}
    if [ $? -eq 0 ]; then
        echo -e "\n${mod} completed successfully!\n"
        continue
    else
        echo "${mod} failed. Please investigate." >&2
        exit 1
    fi
done

# All done.
echo "Deployment completed at $(date)."
exit 0
