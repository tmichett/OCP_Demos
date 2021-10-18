#!/bin/sh

SYSTEMCTL=/usr/bin/systemctl

case "$1" in
    battery)
        echo 'Running on battery. Making sure to remove the inhibit lock'
        $SYSTEMCTL stop suspend-prevent.service
        ;;

    ac)
        echo 'Running on AC. Making sure to add the inhibit lock'
        $SYSTEMCTL start suspend-prevent.service
        ;;

    -h|--help|help)
        echo "Usage: $(basename $0) [battery|ac|--forever]"
        exit 1
        ;;

    --forever)
        /usr/bin/systemd-inhibit --what=handle-lid-switch:sleep --who=$(id -un $(whoami)) --why="Prevent suspend on lid close when on AC" --mode=block /usr/bin/bash -c "while true; do sleep 60; done"
        ;;

    *)
        echo 'Automatically detecting power source...'

        if cat /sys/class/power_supply/AC/online | grep 0 > /dev/null 2>&1
        then
            $0 battery
        else
            $0 ac
        fi

        exit $?
        ;;
esac

exit 0
