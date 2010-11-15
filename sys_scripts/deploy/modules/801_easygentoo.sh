#!/bin/bash
# This module installs my "easygentoo" utils onto the system.
# Currently does each one by hand. Need to clean up the project 
# to make deployment cleaner. Also, kernel update utils aren't 
# needed and gentooupdate.sh needs to be removed/deprecated.

back="$(pwd)"
targetDir='/usr/local/sbin/'
files='https://github.com/tsuehpsyde/easygentoo/raw/master/etc-update-diff.sh \
       https://github.com/tsuehpsyde/easygentoo/raw/master/gentooupdate.py'
# Needed due to github's SSL cert
wgetArgs='--no-check-certificate'

# Create the folder if it's not there
[ ! -d "${targetDir}" ] && mkdir ${targetDir}
cd ${targetDir} || exit 1

echo "Installing our easygentoo files."
for item in ${files}; do
    ourFile="$(basename ${item})"
    echo "Installing ${ourFile}"
    wget ${wgetArgs} ${item} || exit 1
    chmod 750 ${ourFile} || exit 1
    echo "Installed ${ourFile}"
done

cd ${back}
exit 0
