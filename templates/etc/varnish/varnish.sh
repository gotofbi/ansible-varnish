#!/bin/bash
ROOT_UID="0"

#Check if run as root
if [ "$UID" -ne "$ROOT_UID" ] ; then
    echo "You must be root to do that!"
    exit 1
fi

# Getting the PID of the process
PID=`pgrep varnishd`

# Number of seconds to wait before using "kill -9"
WAIT_SECONDS=10

# Counter to keep count of how many seconds have passed
count=0

while kill $PID > /dev/null
do
    # Wait for one second
    sleep 1
    # Increment the second counter
    ((count++))

    # Has the process been killed? If so, exit the loop.
    if ! ps -p $PID > /dev/null ; then
        break
    fi

    # Have we exceeded $WAIT_SECONDS? If so, kill the process with "kill -9"
    # and exit the loop
    if [ $count -gt $WAIT_SECONDS ]; then
        kill -9 $PID
        break
    fi
done
echo "Varnish has been killed after $count seconds."

if test "$1" == "default"
then
    echo "Applying default.vcl config"
    sed -i 's/emergency.vcl/default.vcl/' /etc/default/varnish > /dev/null
elif test "$1" == "emergency"
then
    echo "Applying emergency.vcl config"
    sed -i 's/default.vcl/emergency.vcl/' /etc/default/varnish > /dev/null
else
    echo "Nothing changed"
fi

#Starting varnish
echo "Starting varnish"
service varnish start > /dev/null

