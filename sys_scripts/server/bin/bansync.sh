#!/bin/bash
#
# Script to execute our master banlists from /tmp.
screen -p 0 -X -S css1 stuff "exec fullid.txt"
screen -p 0 -X -S css1 stuff "exec fullid.txt"
sleep 10
screen -p 0 -X -S css1 stuff "writeid"
screen -p 0 -X -S css1 stuff "writeip"
