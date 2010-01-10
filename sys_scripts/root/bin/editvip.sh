#!/bin/bash
#
# Shell script to edit our VIP lists.
# Jim Bair 10/11/2008

# Back up our original fine in case of cancellation
cp /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/reserveslots.txt /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/reserveslots.txt.back

# Edit our list
vim /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/reserveslots.txt

# Make sure we didn't flub up our changes and be able to exit.
echo -n 'Do you want to save this change globally? '
read answer
case $answer in
	y|Y|[yY][eE][sS])
		echo 'Saving changes...'
		;;
	*)
		echo 'Exiting without saving changes.'
		cat /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/reserveslots.txt.back > /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/reserveslots.txt
		rm -f /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/reserveslots.txt.back
		exit 1
		;;
esac

# CD to the dir with the updated file.
cd /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/ 

# Copy our changes over to 2/3/4
for i in 2 3 4; do
	cat reserveslots.txt > /home/srcds${i}/css${i}/cstrike/cfg/mani_admin_plugin/reserveslots.txt
done

# Delete our backup
rm -f /home/srcds1/css1/cstrike/cfg/mani_admin_plugin/reserveslots.txt.back

echo 'Success! All VIP lists edited and saved.'
exit 0
