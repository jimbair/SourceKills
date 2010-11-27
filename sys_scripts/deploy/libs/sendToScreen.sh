#!/bin/bash
# This library will send (stuff) a message, with a new line, to execute
# the command sent into the screen provided. 
# This code will not format correctly outside of vim due to the ^M

sendToScreen() {

    ourScreen="$1"
    shift
    ourCommand="$@"
    screen -p 0 -S "$ourScreen" -X stuff "$ourCommand" || exit 1

}

export -f sendToScreen
