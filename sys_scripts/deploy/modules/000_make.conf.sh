#!/bin/bash
# Patch${ourFile} with any changes we need.
rsyncMirror='rsync://mirrors.rit.edu/gentoo-portage'
httpMirror='http://mirrors.rit.edu/gentoo/'
ourFile='/etc/make.conf'

# Make sure we have a file
checkForFile ${ourFIle}

# Add rsync mirror
if [ -z "$(egrep '^SYNC=' ${ourFile})" ]; then
    echo "Adding our rsync server to ${ourFile}"
    echo "SYNC='${rsyncMirror}'" >> /etc/make.conf
else
    echo "Skipping SYNC value in ${ourFile} - already exists."
fi

# Add http mirror
if [ -z "$(egrep '^GENTOO_MIRRORS=' ${ourFile})" ]; then
    echo "Adding our http server to ${ourFile}"
    echo "GENTOO_MIRRORS='${httpMirror}'" >> /etc/make.conf
else
    echo "Skipping GENTOO_MIRROR value in ${ourFile} - already exists."
fi

# All done
exit 0
