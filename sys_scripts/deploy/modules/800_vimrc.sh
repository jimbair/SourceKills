#!/bin/bash
# Patch global vimrc to do what I want it to do. =)
# Needs to not re-make the header each time. Need to 
# get back to that at some point.

vimconf='/etc/vim/vimrc'
values='smartindent tabstop=4 shiftwidth=4 expandtab'

#echo -e "\n\" Added by $(basename $0)" >> ${vimconf}
#echo "\" $(date)" >> ${vimconf}
#
#for value in ${values}; do
#    egrep "^${value}" ${vimconf} &>/dev/null && continue
#    echo ${value} >> ${vimconf}
#done
# Commented out -- new gentoo-syntax is breaking this. Need
# to fix.

exit 0
