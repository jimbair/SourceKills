#!/bin/bash
# This module installs my "easygentoo" utils onto the system.
# Currently does each one by hand. Need to clean up the project 
# to make deployment cleaner. Also, kernel update utils aren't 
# needed and gentooupdate.sh needs to be removed/deprecated.

# Where we are/where we're going
back="$(pwd)"
targetDir='/usr/local/sbin/'

# Files we're going to install
baseURL='https://github.com/tsuehpsyde/easygentoo/raw/master/'
files="${baseURL}etc-update-diff.sh ${baseURL}gentooupdate.py"

# Needed due to github's SSL cert
wgetArgs='--no-check-certificate'

# Create the folder if it's not there
[ ! -d "${targetDir}" ] && mkdir ${targetDir}
cd ${targetDir} || exit 1

# Install our files
echo "Installing our easygentoo files."
for item in ${files}; do
    ourFile="$(basename ${item})"
    echo "Installing ${ourFile}"
    wget ${wgetArgs} ${item} || exit 1
    chmod 750 ${ourFile} || exit 1
    echo "Installed ${ourFile}"
done

# All done.
cd ${back}
exit 0
