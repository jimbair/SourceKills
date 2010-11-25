#!/bin/bash
# Installs the locate command

# Install our package if needed.
emerge -u mlocate || exit 1

# Run updatedb to get it ready for use.
echo -n "Running updatedb for mlocate..."
locate messages &>/dev/null || updatedb || exit 1
echo 'done.'

# All done.
exit 0
