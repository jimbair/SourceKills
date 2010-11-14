#!/bin/bash
# This module installs an up-to-date portage snapshot onto the server.
# By default, slicehost doesn't install a portage snapshot at all.

# There is no portage to begin with. Let's install one.
snapurl='http://mirrors.rit.edu/gentoo/snapshots/portage-latest.tar.bz2'
md5url="${snapurl}.md5sum"
snapshot="$(basename ${snapurl})"
md5file="$(basename ${md5url})"

# Where to go back to
back="$(pwd)"

# Make sure our file isn't already here.
if [ -s "${snapshot}" -o -s "${md5file}" ]; then
    echo "Either our snapshot or md5sum file already exists." >&2
    exit 1
fi

# Fetch our portage snapshot.
cd /tmp
wget ${snapurl} || exit 1
wget ${md5url} || exit 1
md5sum -c ${md5file} || exit 1

# Extract and sync with the internet
tar xvjf ${snapshot} -C /usr || exit 1
rm -f ${snapurl} ${md5url}
cd ${back}

# Finally sync the live tree =)
emerge --sync || exit 1

# All done
exit 0
