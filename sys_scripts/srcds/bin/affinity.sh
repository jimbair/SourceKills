#!/bin/bash
# Script to set affinity of our SourceDS processes.

# Find the number of procs we have
procNum="$(egrep -c '^cpu family+[[:space:]]:' /proc/cpuinfo)"
if [ $procNum -eq 0 ]; then
    echo "Unable to find the number of processors." >&2
    exit 1
fi

# Find our SourceDS processes, sort them by usernames, then pull out PIDs
pids="$(pidof srcds_linux)"
if [ -z "$pids" ]; then
    echo "Unable to find our processes." >&2
    exit 1
fi

# Make sure we don't have more pids than procs
pidsNum="$(echo $data | wc -w)"
if [ $pidsNum -gt $procNum ]; then
    echo "We have $dataNum processes and only $procNum processors." >&2
    exit 1
fi

# Start with highest affinity and go down
count="$((${procNum}-1))"

for pid in $pids; do
    sudo taskset -cp $count $pid
    if [ $? -ne 0 ]; then
        echo "Running 'taskset -cp $count $pid' failed." >&2
        exit 1
    fi
    # Go to the next processor down
    let count--
done

echo 'SUCCESS: All PIDs assigned to their correct affinity.'
exit 0
