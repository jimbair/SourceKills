#!/bin/bash
# Patch locale.gen to only do stuff for en_US
ourFile='/etc/locale.gen'
string1='en_US ISO-8859-1'
string2='en_US.UTF-8 UTF-8'
if [ ! -s "${ourFile}" ]; then
    echo "${ourFile} is missing." >&2
    exit 1
fi

# Only patches if we need to
for string in "${string1}" "${string2}"; do
    if [ -n "$(egrep "^#${string}" "${ourFile}")" ]; then
        echo -n "Patching for ${string}..."
        sed -i "s/#${string}/${string}/" ${ourFile}
        echo "done."
    else
        echo "Skipping ${string} - already patched."
    fi
done
exit 0
