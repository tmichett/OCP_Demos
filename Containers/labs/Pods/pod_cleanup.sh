#!/usr/bin/env bash

podman rm -f db wp
podman pod rm -f wordpress_demo_pod
podman volume prune

# This will display message when cleanup has completed.
echo "The Pod Demo has completed and is cleaned up!!"
