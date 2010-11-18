#!/bin/bash
# This module configures our inittab.
# This fixes the respawning errors in syslog. 
# Pretty sure this is specific to our Xen slices

ourFile='/etc/inittab'
string='cX:12345:respawn:/sbin/agetty 38400 ttyX linux'

# Make sure our file exists
echo "Checking if ${ourFile} exists."
[ -s "${ourFile}" ] || exit 1

# Patch our file as needed.
for X in $(seq 2 6); do

    # Build the string we need to patch
    newString="$(echo ${ourString} | sed s/X/${X}/g)"
    [ -z "${newString}" ] && echo "Can't build our new string" && exit 1
    echo "Working on $newString."

    # Make sure it needs patched
    echo "Checking if we need to patch ${ourFile}."
    egrep "^${newString}$" ${ourFile} || continue

    # Patch it if we're still here
    echo -n "Patching..."
    sed -i "s/${newString}/#${newString}/g" || exit 1
    echo 'done.'

done

# All done
exit 0
