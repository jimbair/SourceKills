#!/bin/bash
# This module automatically merges all changes
# proposed by etc-update. Done with screen to 
# automate the process.

ourCommand1='etc-update' # Spawn etc-update
ourCommand2='-5' # Auto-Merge Updates
ourScreen='etcScreen1'
sleepTime='10'

echo -n "Spawning ${ourCommand1} in screen ${ourScreen}..."
runInScreen "${ourScreen}" "${ourCommand1}" || exit 1
echo 'done.'

echo "Sleeping for ${sleepTime} seconds."
sleep ${sleepTime}

if [ -n "$(screen -list | grep "${ourScreen}")" ]; then
    echo -n "Spawning ${ourCommand2} in screen ${ourScreen}..."
    sendToScreen "${ourScreen}" "${ourCommand2}" || exit 1
    echo 'done.'
else
    echo "Screen already closed - no updates."
    exit 0
fi

echo "Sleeping for ${sleepTime} seconds."
sleep ${sleepTime}

echo -n "Checking if screen exited..."
if [ -z "$(screen -list | grep "${ourScreen}")" ]; then
    echo 'done.'
else
   echo 'failed.'
   echo "Screen ${ourScreen} is still alive." >&2
   exit 1
fi

exit 0
