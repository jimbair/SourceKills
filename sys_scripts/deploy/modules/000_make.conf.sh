#!/bin/bash
# Patch make.conf with any changes we need.
rsyncMirror='rsync://mirrors.rit.edu/gentoo-portage'
httpMirror='http://mirrors.rit.edu/gentoo/'

# Add rsync mirror
if [ -z "$(egrep '^SYNC=' /etc/make.conf)" ]; then
    echo "Adding our rsync server to make.conf"
    echo "SYNC='${rsyncMirror}'" >> /etc/make.conf
else
    echo "Skipping SYNC value in make.conf - already exists."
fi

# Add http mirror
if [ -z "$(egrep '^GENTOO_MIRRORS=' /etc/make.conf)" ]; then
    echo "Adding our http server to make.conf"
    echo "GENTOO_MIRRORS='${httpMirror}'" >> /etc/make.conf
else
    echo "Skipping GENTOO_MIRROR value in make.conf - already exists."
fi

# All done
exit 0
