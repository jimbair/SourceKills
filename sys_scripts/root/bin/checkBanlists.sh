#!/bin/bash
for i in $(seq 4); do
	if [ -s /home/srcds${i}/css${i}/cstrike/cfg/banned_user.cfg ]; then
		echo -n "Server #${i} is good - "
		echo "$(cat /home/srcds${i}/css${i}/cstrike/cfg/banned_user.cfg | wc -l) bans present."
	else
		echo "ERROR: Server #${i} has NO BANS." >&2
	fi
done
exit 0
