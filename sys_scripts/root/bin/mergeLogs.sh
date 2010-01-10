#!/bin/bash
# Script to consolidate log files
#
# v1.0 - Ready For Primetime jbair@2009-06-28
# v1.1 - Not quite - still making better.
# v1.2 - Possibly ready to use
# v2.0 - Written to be run by root for all 4
# v2.1 - Stable and now in github.
# Last updated 2010-01-10

# Our servers, should all be users in /home
servers="srcds1 srcds2 srcds3 srcds4"
ourScript=$(basename $0)

# Make sure we can quit
trap leave 2
leave() {
    echo 'Caught SIGINT, Exiting.'
    exit 1
}

# Must be run as root
if [[ $UID -ne 0 ]]; then
    echo "ERROR: This script must be run as root! Exiting." >&2
    exit 1
fi

# Starting out
echo "$ourScript has started running at $(date)"

# Set this process to a nice value of 19
# so we don't break things too badly.
renice 19 --pid $$ > /dev/null 2>&1

for server in $servers; do
    # Make sure our servers are here.
    root="$(ls /home/$server | egrep 'css[0-9]')"
    child="$(ls /home/$server/$root | egrep 'cstrike')"
    dest="/home/${server}/${root}/${child}/logs/"

    if [[ ! -d "$dest" ]]; then
        echo "The server ${server}'s logs are missing." >&2
        echo "Logs checked: $dest" >&2
        exit 1
    fi
    
    echo "Working on logs in $dest"
    cd $dest

    # Done for compatibility reasons
    ourServer="$server"

    # Find the newest file and skip that so we don't 
    # cause the gameserver to freak out. 
    newestFile=$(ls -c L*.log | head -1)
    
    # Find all of our log files, oldest to newest
    for file in $(ls -cr L*.log); do

        # Make sure we haven't reached the latest file yet
        if [[ "$file" == "$newestFile" ]]; then
            echo "Reached current log file $file - breaking"
            break
        fi

        # Make sure they are files and not empty
        if [[ -f "$file" && -s "$file" ]]; then 
            
            # Get more specific data, one file 
            # at a time since BASH has lame arrays.
            ourData=$(ls -al --time-style=long-iso $file)
            # Get filename
            ourFile=$(echo $ourData | awk '{print $NF}')
            # Set filename from timestamp and strip out the day
            # leaving only year/month
            newFile=$(echo $ourData | awk '{print $6}' | cut -d '-' -f -2)    
            # Add .csslog to the end =
            fullFile="${newFile}.csslog"

            # Make sure we're not in thunderdome
            # Adding .log above makes this obsolete.
            if [[ "$file" == "$fullFile" ]]; then
                continue
            fi
            
            # Create our file
            if [[ ! -f $fullFile ]]; then
                touch $fullFile
                # chown to proper perms if deploying into production
                if [[ "$ourServer" != "testing" ]]; then
                    chown ${ourServer}.apache $fullFile
                fi
            fi
            # Merge into the new file
            echo "Merging $ourFile into logfile $fullFile"
            cat $ourFile >> $fullFile

            # Remove the merged file
            rm $ourFile
            
        # What we do with empty files - Just delete them.
        elif [[ -f "$file" ]]; then
            echo "Empty file $file found - deleting."
            rm -f $file
        fi
    done
done

# All done
echo "$ourScript has finished running at $(date)"
exit 0
