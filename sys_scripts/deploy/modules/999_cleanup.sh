#!/bin/bash
# A script to do cleanup of the system to remove any old 
# stuff that is laying around.

echo "Cleaning up any left over bits."
emerge --prune || exit 1
rm -fr /usr/portage/distfiles/* || exit 1
echo "Done with cleanup on our system."

exit 0
