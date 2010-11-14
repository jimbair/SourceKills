#!/bin/bash
# Installs the following system packages. None of these 
# should require any configuration.
packages='host iftop iptraf netcat nmap screen slocate telnet-bsd whois'
emerge -u ${packages} || exit 1
echo "Running updatedb for slocate."
updatedb || exit 1
exit 0
