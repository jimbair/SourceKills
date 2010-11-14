#!/bin/bash
# Script to set our new gcc compiler

echo "Checking if we need to update our gcc profile."

curVer="$(gcc-config -l | egrep '\*' | awk '{print $2}')"
newVer="$(gcc-config -l | tail -1 | awk '{print $2}')"

if [ "${curVer}" != "${newVer}" ]; then
    echo "Switching GCC from: ${curVer} to ${newVer}"
    gcc-config ${newVer} || exit 1
    source /etc/profile || exit 1
else
    echo "Already running current version of GCC: ${curVer}"
fi

exit 0
