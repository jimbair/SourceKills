#!/bin/bash
# Script to update a Gentoo 10.1 system from Slicehost 
# up to the latest versions of packages.

# Remove any blocking packages
echo "Checking for any blocking packages."
badOnes="$(emerge -pu portage 2>&1 | awk '$1 ~ /blocks/ {print $4}')"
if [ -n "${badOnes}" ]; then
    echo "Removing the following blocking packages: ${badOnes}"
    for package in ${badOnes}; do
        emerge --unmerge ${package} || exit 1
    done
else
    echo "No blocking packages found."
fi

# Emerge portage FIRST
echo "Proceeding with portage package update."
emerge -u portage || exit 1
echo "Finished updating portage."

# Emerge gentoolkit if we need it
echo "Installing Gentoolkit if needed."
emerge -u gentoolkit

# Now update everything!
echo "Proceeding with updating entire OS."
# First one can sometimes fail with lots of updates due to order
emerge -uDN world || emerge -uDN world || exit 1

# Required after upgrades. If not needed, doesn't hurt anything.
perl-cleaner --all || exit 1
python-updater || exit 1

# Now check for packages missed by portage
missed="$(emerge -ep world | grep 'ebuild     U' | awk '{print $4}')"
if [ -n "${missed}" ]; then
    for i in ${missed}; do
        emerge -u =${i} || exit 1
    done
fi

# Clean up work
revdep-rebuild || exit 1
makewhatis -u || exit 1
etc-update
echo "Finished updating entire OS."

# All done
exit 0
