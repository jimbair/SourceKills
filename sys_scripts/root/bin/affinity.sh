#!/bin/bash
# Script to set affinity of our SourceDS processes.

# Find the number of procs we have
procNum="$(egrep -c '^cpu family+[[:space:]]:' /proc/cpuinfo)"
if [ $procNum -eq 0 ]; then
    echo "Unable to find the number of processors." >&2
    exit 1
fi

# Find our SourceDS processes, sort them by usernames, then pull out PIDs
data="$(ps au | grep './srcds_linux' | grep srcds | grep -v grep | sort | awk '{print $2}')"
if [ -z "$data" ]; then
    echo "Unable to find our processes." >&2
    exit 1
fi

# Make sure we don't have more pids than procs
dataNum="$(echo $data | wc -l)"
if [ $dataNum -gt $procNum ]; then
    echo "We have $dataNum processes and only $procNum processors." >&2
    exit 1
fi

# Start with affinity zero and go up.
count=0

for process in $data; do
    taskset -cp $count $process
    if [ $? -ne 0 ]; then
        echo "Running 'taskset -cp $count $process' failed." >&2
        exit 1
    fi
    # Increase our processor to go to
    let count++
done

echo 'SUCCESS: All PIDs assigned to their correct affinity.'
exit 0
