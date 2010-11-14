#!/bin/bash
# This is a script to quickly get Gentoo 10.1 64-bit 
# up and running after deployment of a slice.
# It then runs modules in order, numerically, and 
# configures the system for use.
#
# Designed for SourceKills and Slicehost

# Arch vars
arch='x86_64'
systemArch="$(uname -m)"

# Module vars
modules="$(dirname $0)/modules/"
modExt='.sh'
ourMods="$(ls ${modules}*${modExt} | sort)"

# Make sure we are root and in Gentoo
if [ "${UID}" -ne 0 ]; then
    echo "This script must be run as root." >&2
elif [ ! -s '/etc/gentoo-release' ]; then
    echo "This is not a Gentoo system." >&2
    exit 1
# We expect a 64-bit system
elif [ "${systemArch}" != "${arch}" ]; then
    echo "This is supposed to be an ${arch} platform." >&2
    exit 1
# Make sure we have some modules
elif [ ! -d "${modules}" -o -z "${ourMods}" ]; then
    echo "No modules found to source!" >&2
    exit 1
fi

# Start
echo "Deployment started at $(date)."

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
