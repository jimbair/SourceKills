#!/bin/bash
# Script to update a Gentoo 10.1 system from Slicehost 
# up to the latest versions of packages.

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
clear
emerge -uDN world || emerge -uDN world || exit 1

# Required after perl upgrades. If not needed, doesn't hurt anything.
perl-cleaner --all

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
