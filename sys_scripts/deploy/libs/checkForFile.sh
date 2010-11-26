#!/bin/bash
# Check if a file exists and is not empty.
checkForFile() {

    ourFile=$1

    if [ ! -s "${ourFile}" ]; then
        echo "${ourFile} is missing." >&2
        exit 1
    fi

}

export -f checkForFile
