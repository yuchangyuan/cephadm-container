podman build \
  --security-opt=seccomp=unconfined \
  --net=host \
  -t cephadm-container:v0.10.1 \
  .
