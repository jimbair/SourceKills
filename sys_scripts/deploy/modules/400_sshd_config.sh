#!/bin/bash
# This module tweaks the sshd config to our needs.
ourFile='/etc/ssh/sshd_config'

if [ ! -s "${ourFile}" ]; then
    echo "Our file ${ourFile} is missing." >&2
    exit 1
fi

# Patch and restart sshd
echo "Patching our sshd config."
sed -i "s/#PermitRootLogin yes/PermitRootLogin without-password/" ${ourFile}
echo "Done patching our sshd config."
/etc/init.d/sshd restart || exit 1

exit 0
