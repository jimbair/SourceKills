#!/bin/bash
# Installs the following system packages. None of these 
# should require any configuration.
packages='ftp host iftop iptraf lsof mlocate netcat nmap rar rdiff-backup 
          screen strace tcpdump telnet-bsd unrar unzip whois zip'

# Install our packages if needed.
emerge -u ${packages} || exit 1

# The only client package we should be "configuring"
echo -n "Running updatedb for mlocate..."
updatedb || exit 1
echo 'done.'

# All done.
exit 0
