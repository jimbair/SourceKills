# Quick and dirty workaround to block people from using the channel overflow client disconnect exploit
# Original author: Lobster Man
# Contact: AIM - lobsterman246, Steam - lobster_man246
# Websites: www.f10community.com & www.newslobster.com
#
# Modified for SourceKills by tsuehpsyde
# Changes:
#          -modified the ban/kick section to be easier to 
#           comment out and add custom ban messages.
# 
#          -Fixed repeated attempts to ban/kick user in watch_console()
#             - Now stops 20 reset commands from being run
# v1.0

import es
import gamethread

# Create blank users dictionary
users = {}
countwaiting = {}
banwaiting = {}

# Create blank list
banned = []

# Set to true for debugging purposes
debug = False

def load():
    #hooking the commands, not sure if ma_timeleft and ma_nextmap are actually necessary
    es.regclientcmd('timeleft', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regclientcmd('ma_timeleft', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regclientcmd('nextmap', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regclientcmd('ma_nextmap', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regclientcmd('listmaps', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regsaycmd('ff', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regsaycmd('@timeleft', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regsaycmd('@nextmap', 'block_crash/watch_console', 'test to block channel overflow exploit')
    es.regsaycmd('@listmaps', 'block_crash/watch_console', 'test to block channel overflow exploit')


def player_connect(event_var):
    #don't let client connect if they're using the unconnected trick
    if event_var['name'] == '':
        es.ServerCommand('kickid %s You cannot connect to this server without a name' % event_var['userid'])
    
    # add users to the dictionaries on connect
    users[event_var['userid']] = 0
    countwaiting[event_var['userid']] = 0
    banwaiting[event_var['userid']] = 0

    
def watch_console():

    # Get our already_banned list
    global banned

    # Get our UserID and SteamID
    userid = str(es.getcmduserid())
    steam = es.getplayersteamid(userid)
    name = es.getplayername(userid)

    # Each time a user calls one of the above commands, increment a count in the users dictionary
    if userid in users:
        users[userid] += 1
    # Added in case the module is reloaded
    else:
        users[userid] = 1

    # Do the same check for waiting
    if userid not in countwaiting:
        countwaiting[userid] = 0
    
    if userid not in banwaiting:
        banwaiting[userid] = 0
        
    # If user attempts to issue a command more than 3 times, ban them.
    if users[userid] >= 3:
            
        # See if this user's been set to be banned already
        if steam not in banned:
            
            # Let python know we're already banning the user - this is to avoid tons of spam in console
            banned.append(steam)
            
            #*******************************************************
            # tsuehpsyde@2009-07-22 - Changed to allow ban/kick with a custom message
            # Comment out the banid line if you only want to kick.
            es.ServerCommand('banid 0 %s' % steam)
            es.ServerCommand('kickid %s Attempted channel overflow exploit' % steam)
            #*******************************************************
            
            # Message printed to all users in the game
            es.msg('User %s was kicked and banned for attempting to use the channel overflow exploit' % name)
            # This next line prints out their steamid as well for easy identification
            es.msg('----SteamID of the n00b: %s' % steam)
        else:
            # Not needed, but good for when debugging.
            if debug:
                es.msg('Already banned %s' % steam)
    
    # We only want the following sleep/reset to happen once, not 20 times.      
    if countwaiting[userid] == 0:
        # Let everyone know we're already waiting to reset
        countwaiting[userid] += 1

        # Wait 5 secs then reset their count - you can change this if you want but players shouldn't need to execute one of the above commands more than once every 5 seconds
        gamethread.delayed(5, countreset, userid)
    
    # Check to see if we're currently sleeping.
    if banwaiting[userid] == 0:

        # See if the user's been banned yet if not sleeping.
        if steam in banned:

            # We are now banning the user - let other threads know this.
            banwaiting[userid] += 1
            
            # Remove our SteamID from the list after 5 seconds
            gamethread.delayed(5, banned.remove, steam)
            gamethread.delayed(5, banreset, userid)

    
def countreset(sessionid):
    users[sessionid] = 0
    countwaiting[sessionid] = 0

def banreset(sessionid):
    banwaiting[sessionid] = 0

# cleanup below here    
def player_disconnect(event_var):
    del users[event_var['userid']]
    
def unload():
    es.unregclientcmd('timeleft')
    es.unregclientcmd('ma_timeleft')
    es.unregclientcmd('nextmap')
    es.unregclientcmd('ma_nextmap')
    es.unregclientcmd('listmaps')
    es.unregsaycmd('ff')
    es.unregsaycmd('@timeleft')
    es.unregsaycmd('@nextmap')
    es.unregsaycmd('@listmaps')
