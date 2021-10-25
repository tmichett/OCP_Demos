#!/usr/bin/bash
DATE=`date '+%Y-%m-%d %H:%M:%S'`
echo "This is a sample service started at ${DATE} for the SystemD Custom course." | systemd-cat -p info
while :
do
echo "Looping..."; sleep 30;
done
