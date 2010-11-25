#!/bin/bash
# Turn off eth1 - we currently don't use this guy.
ifconfig eth1 down || exit 1
removeFromStart net.eth1
exit 0
