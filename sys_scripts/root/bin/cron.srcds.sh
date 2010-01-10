#!/bin/bash
# 
# Script to run in cron as root to set renice/affinity to 
# our SourceDS processes. Also available for any other 
# maintenance work that may need done from  here.

rscript=/root/bin/renice.sh
ascript=/root/bin/affinity.sh

if [ -x $rscript ] && [ -x $ascript ]; then
	echo "Beginning the clean up of our SourceDS processes at `date`."
	$rscript
	$ascript
	echo "The clean up of our SourceDS processes finished at `date`."
	exit 0
else
	echo "ERROR: Either $rscript or $ascript is either missing or empty. Cannot proceed."
	exit 1
fi
