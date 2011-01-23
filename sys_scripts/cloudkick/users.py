#!/usr/bin/python -tt
# Small CloudKick Plugin to see who's logged into the system.
# Alerts if anyone is logged in.

import commands
import sys

def getUsersLoggedIn():
    """
    Find all users that are logged 
    into the local system and return
    either a list or a None object.
    """
    
    # Best way I can find to find users logged in
    userData = commands.getoutput('who').strip()
    
    # "who" returns an empty string if no one is logged in
    if userData == '':
        users = None
    else:
        # We're going to add each user we find to a list
        users = []
        # Split up our string by lines
        userLines = userData.split('\n')
        for line in userLines:
            # Username should be the first item on the line
            users.append(line.split()[0])

    return users

# Let's do this
if __name__ == '__main__':

    # Find our users
    users = getUsersLoggedIn()

    # Currently only supports zero or anything else.
    # Should be easy to add support for X number of 
    # users to be okay, but >X alerting.
    if users is None:
        sys.stdout.write("status ok No users logged in.\n")
        sys.exit(0)
    else:
        sys.stderr.write("status err %d users logged in:" % (len(users),))
        for user in users:
            sys.stderr.write(" %s" % (user,))
        sys.stderr.write('\n')
        sys.exit(1)
