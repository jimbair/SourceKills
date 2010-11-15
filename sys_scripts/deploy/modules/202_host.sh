#!/bin/bash
# Installs the host package and symlinks host to hostx

back="$(pwd)"

# Install our package if needed.
emerge -u host || exit 1

# Setup the symlink if needed
echo -n "Creating our symlink..."
cd $(dirname $(which host)) || exit 1
# Only create symlink if nothing exists
[ ! -e host ] && ln -s host hostx || exit 1
cd ${back} || exit 1
echo 'done.'

# All done.
exit 0
