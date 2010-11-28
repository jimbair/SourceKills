#!/bin/bash
# This module will set the root password if given one.

read -p "Please enter desired root password (press enter to skip): " rootPW
[ -z "${rootPW}" ] && exit 0

echo -n "Setting root password..."
echo "root:${rootPW}" | chpasswd || exit 1
echo 'done.'

exit 0
