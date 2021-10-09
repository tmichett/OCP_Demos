# you have to run this as root
# It only runs on Linux (namespaces and cgroups only exist on Linux)
# if you don't have it, cgcreate is in the libcgroup package

set -eux # let's be safe

# Download the container (it's in a github gist published by my github account)
# This is just the frapsoft/fish Fish Docker container flattened into a single tarball
# You can also easily make your own tarball to run instead of this one  with `docker export`
wget bit.ly/fish-container -O fish.tar

# extract fish.tar into a directory
mkdir container-root
cd container-root
tar -xf ../fish.tar
# generate a random cgroup id
uuid="cgroup_$(shuf -i 1000-2000 -n 1)"
# create the cgroup
cgcreate -g "cpu,cpuacct,memory:$uuid"
# assign CPU/memory limits to the cgroup
cgset -r cpu.shares=512 "$uuid"
cgset -r memory.limit_in_bytes=1000000000 "$uuid"
# The following line does a lot of work:
# 1. cgexec: use our new cgroup
# 2. unshare: make and use a new PID, network, hostname, and mount namespace
# 3. chroot: change root directory to current directory
# 4. mount: use the right /proc in our new mount namespace
# 5. hostname: change the hostname in the new hostname namespace to something fun
cgexec -g "cpu,cpuacct,memory:$uuid" \
    unshare -fmuipn --mount-proc \
    chroot "$PWD" \
    /bin/sh -c "/bin/mount -t proc proc /proc && hostname container-fun-times && /usr/bin/fish"

# Here are ome fun things to try once you're running your container!
# Run them both in the container and in a normal shell and see the difference
# - ps aux
# - ifconfig
# - hostname
