#!/bin/bash
# Simply remove any news updates. We don't much 
# care about those on a brand new server.

echo "Clearing out news articles from portage."
eselect news read all &>/dev/null || exit 1
echo "News articles from portage cleared out."

exit 0
