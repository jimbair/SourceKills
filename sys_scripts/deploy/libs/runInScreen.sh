#!/bin/bash
# This library takes a given command and 
# sends it to the screen name provided.

runInScreen() {

    ourScreen="$1"
    shift
    ourCommand="$@"
    screen -dmS "${ourScreen}" ${ourCommand} || exit 1

}

export -f runInScreen
