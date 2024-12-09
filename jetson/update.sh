#!/bin/sh

if [ ! -e "/sys/class/gpio/gpio15/value" ]; then
    echo "set fan high"
    echo 15 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio15/direction
    echo 1 > /sys/class/gpio/gpio15/value
fi
