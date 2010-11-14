#!/bin/bash
# Patch locale.gen to only do stuff for en_US
ourFile='/etc/locale.gen'
if [ ! -s "${ourFile}" ]; then
    echo "${ourFile} is missing." >&2
    exit 1
fi

sed -i 's/#en_US ISO-8859-1/en_US ISO-8859-1/' ${ourFile}
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' ${ourFile}

exit 0
