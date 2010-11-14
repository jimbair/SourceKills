#!/bin/bash
# Turn off eth1 - we currently don't use this guy.
ifconfig eth1 down || exit 1
rc-update del net.eth1 default || exit 1
exit 0
