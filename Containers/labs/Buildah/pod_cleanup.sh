#!/usr/bin/env bash

sudo podman rm -f db wp
sudo podman pod rm -f wordpress_demo_pod
sudo podman volume rm sqlvol -f

# This will display message when cleanup has completed.
echo "The Pod Demo has completed and is cleaned up!!"
