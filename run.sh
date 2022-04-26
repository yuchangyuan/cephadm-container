#!/bin/sh

mkdir -p /var/log/ceph
mkdir -p /etc/ceph/ssh
mkdir -p /var/lib/ceph/containers

podman run --rm -d \
  --net=host \
  --privileged=true \
  --name=cephadm3 \
  -v /var/lib/ceph/containers:/var/lib/containers:z \
  -v /var/lib/ceph:/var/lib/ceph:z \
  -v /var/log/ceph:/var/log/ceph:z \
  -v /etc/ceph:/etc/ceph:z \
  -v /dev:/dev:z \
  cephadm-container:v0.5
