#!/bin/bash
# Installs the following system packages. None of these 
# should require any configuration.
packages='ftp host iftop iptraf ipython lsof netcat nmap rar rdiff-backup
          screen strace tcpdump telnet-bsd unrar unzip whois zip'

# Install our packages if needed.
emerge -u ${packages} || exit 1

# All done.
exit 0
