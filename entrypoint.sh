#!/bin/bash

mkdir -p /etc/ceph/ssh
chmod 700 /etc/ceph/ssh

# copy 
L=/etc/systemd/_system
U=/etc/ceph/systemd/system
W=/etc/ceph/systemd/.work

mkdir -p $U
mkdir -p $W

cp -a /etc/systemd/system $L

mount -t overlay overlay \
    -o lowerdir=$L,upperdir=$U,workdir=$W \
    /etc/systemd/system

exec /sbin/init
