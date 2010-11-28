#!/bin/bash
# This module will set the root password if given one.
pwSet='no'
while [ "${pwSet}" == 'no' ]; do

    read -p "Please enter desired root password (press enter to skip): " rootPW

    # If nothing given, exit.
    [ -z "${rootPW}" ] && exit 0

    # Make sure the user entered the correct password.
    read -p "You entered '${rootPW}' - is this correct? " answer
    # Convert to lower case
    answer="$(echo ${answer} | tr A-Z a-z)"
    case ${answer} in
        yes|y)
            pwSet='yes'
            ;;
        no|n)
            echo "Okay - resetting password. Let's try again."
            ;;
        *)
            echo "${answer} not understood - starting over."
            ;;
    esac
done

# Change our password and exit.
echo -n "Setting root password to ${rootPW}..."
echo "root:${rootPW}" | chpasswd || exit 1
echo 'done.'

exit 0
