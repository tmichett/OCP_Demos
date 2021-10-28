#!/bin/sh

## Define Container Variable and Mountpoint Variable
ctr=$(buildah from scratch)
mnt=$(buildah mount $ctr)

## Install Files
yumdownloader --destdir=/tmp redhat-release-server
rpm -ivh --root $mnt /tmp/redhat-release-8.4-0.6.el8.x86_64.rpm
cp  /etc/yum.repos.d/rhel_dvd.repo $mnt/etc/yum.repos.d/
yum -y install --installroot $mnt httpd
echo "This is a custom webserver container for me" >> $mnt/var/www/html/index.html
yum -y install --installroot $mnt httpd-manual


## Configure Container Image
buildah config --cmd "/usr/sbin/httpd -DFOREGROUND" $ctr
buildah config --port 80/tcp $ctr
buildah config --author "Travis Michette <tmichett@redhat.com>" $ctr

## Cleanup Image
yum clean all --installroot $mnt

## Unmount and Commit Image
buildah unmount $ctr
buildah commit $ctr demo-container-image
