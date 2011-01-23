#!/usr/bin/python -tt
# Small CloudKick Plugin to see who's logged into the system.
# Alerts if anyone is logged in.

import commands
import sys

users = commands.getoutput('who').strip()

if users == '':
    sys.stdout.write("status ok No users logged in.\n")
    sys.exit(0)
else:
    users = users.split('\n')
    sys.stderr.write("status err %d users logged in:" % (len(users),))
    for user in users:
        user = user.split()[0]
        sys.stderr.write(" %s" % (user,))
    sys.stderr.write('\n')
    sys.exit(1)
