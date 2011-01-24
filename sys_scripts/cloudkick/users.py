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
    commStatus, userData = commands.getstatusoutput('who')

    # Make sure it exits gracefully
    if commStatus != 0:
        sys.stderr.write('status err Unable to execute "who" command.\n')
        sys.exit(1)
    
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

    # Currently only supports zero or anything else
    # Should be easy to add support for X number of 
    # users to be okay, but >X alerting
    if users is None:
        sys.stdout.write("status ok No users logged in.\n")
        sys.exit(0)
    else:
        # Find out if it's "user" or "users"
        userNum = len(users)
        if userNum == 1:
            userWord = 'user'
        else:
            userWord = 'users'
        # Build our string and report the warning
        sys.stdout.write("status warn %d %s logged in:" % (userNum, userWord)
        for user in users:
            sys.stdout.write(" %s" % (user,))
        sys.stdout.write('\n')
        sys.exit(0)
