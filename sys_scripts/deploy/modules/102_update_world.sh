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
pyVer="$(python --version 2>&1)"
echo "Proceeding with portage package update."
emerge -u portage || exit 1
echo "Finished updating portage."

# Emerge gentoolkit if we need it
echo "Installing Gentoolkit if needed."
emerge -u gentoolkit

# See Gentoo Bug #347081 http://bugs.gentoo.org/show_bug.cgi?id=347081i
py3="$(which python3 2>/dev/null)"
if [ -z "${py3}" ]; then
    emerge -u python
    echo -n "Generating our python3 symlink..."
    eselectOrig="$(eselect python list | grep '*' | cut -d '[' -f 2 | cut -d ']' -f 1)"
    eselectPy3="$(eselect python list | grep 'python3.1' | cut -d '[' -f 2 | cut -d ']' -f 1)"
    if [ -z "${eselectOrig}" -o -z "${eselectPy3}" ]; then
        echo "Unable to find one of our variables:" >&2
        echo "eselectOrig: ${eselectOrig}" >&2
        echo "eselectPy3: ${eselectPy3}" >&2
        exit 1
    fi
    eselect python set ${eselectPy3} || exit 1
    eselect python set ${eselectOrig} || exit 1
    echo 'done.'
else
    echo "Symlink already generated - skipping."
fi

# Generally needs run before world update for dev-libs/libxml2-2.7.7
python-updater || exit 1

# Now update everything!
echo "Proceeding with updating entire OS."
# First one can sometimes fail with lots of updates due to order
emerge -uDN world || emerge -uDN world || exit 1

# Required after upgrades. If not needed, doesn't hurt anything.
python-updater || exit 1
perl-cleaner --all || exit 1

# Python should have been updated as part of portage
echo "Checking if we need to run python-updater."
pyVer2="$(python --version 2>&1)"
if [ "${pyVer}" != "${pyVer2}" ]; then
    echo "Python updated from ${pyVer} to ${pyVer2} - running."
    # Need to swap Python version via eselect to build needed symlink
    # See Gentoo Bug #347081 http://bugs.gentoo.org/show_bug.cgi?id=347081
    eselectOrig="$(eselect python list | grep '*' | cut -d '[' -f 2 | cut -d ']' -f 1)"
    eselectPy3="$(eselect python list | grep 'python3.1' | cut -d '[' -f 2 | cut -d ']' -f 1)"
    eselect python set ${eselectPy} || exit 1
    eselect python set ${eselectOrig} || exit 1
    python-updater || exit 1
else
    echo "Python has not updated from ${pyVer} - skipping."
fi


# Now check for packages missed by portage
missed="$(emerge -ep world | grep 'ebuild     U' | awk '{print $4}')"
if [ -n "${missed}" ]; then
    for i in ${missed}; do
        emerge -u =${i} || exit 1
    done
fi

# Clean up work
revdep-rebuild || exit 1

echo -n "Running 'makewhatis -u'..."
makewhatis -u || exit 1
echo 'done.'

echo "Finished updating entire OS."

# All done
exit 0
