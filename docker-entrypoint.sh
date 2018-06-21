#!/bin/bash

set -e

sigint()
{
    echo "signal INT received, script ending"
    /etc/init.d/avgd stop 
    exit 0
}

if [ "$1" = 'avg' ]; then
    trap 'sigint' INT
    /etc/init.d/avgd start
    /etc/init.d/avgd status
    PID=$(cat /opt/avg/av/var/run/avgd.pid)
    while test -d "/proc/$PID"; do
        sleep 60
    done
fi

exec "$@"