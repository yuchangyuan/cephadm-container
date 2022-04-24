#!/bin/bash

mkdir -p /etc/ceph/ssh
chmod 700 /etc/ceph/ssh

# copy 
mkdir -p /etc/ceph/systemd

rsync -a /etc/ceph/systemd/ /etc/systemd/

exec /sbin/init
