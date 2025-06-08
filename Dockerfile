FROM fedora:42

RUN dnf -y install \
    systemd openssh-server openssh-clients \
    cephadm podman containernetworking-plugins \
    rsync \
    procps \
    less \
    which \
    iproute && \
    dnf clean all

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 && \
    sed -i -e 's/^.*pam_loginuid.so.*$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    sed -i -e 's/^.*Port 22/Port 23/' /etc/ssh/sshd_config

EXPOSE 23

RUN (for i in \
  systemd-network-generator.service \
  rpmdb-migrate.service \
  rpmdb-rebuild.service \
  getty@tty1.service \
  remote-fs.target \
  systemd-resolved.service \
  systemd-oomd.service \
  systemd-network-generator.service \
  dnf-makecache.timer \
  fstrim.timer; do \
  rm -f /etc/systemd/system/*.wants/$i; \
  done; \
  rm /lib/systemd/system/console-getty.service; \
  rm /lib/systemd/system/systemd-vconsole-setup.service; \
)

COPY ./ntp.service /etc/systemd/system

RUN (cd /etc/systemd/system/multi-user.target.wants; \
  ln -s ../ntp.service )

RUN find /etc/systemd | xargs touch -h -t 197001010000

RUN mkdir -p /etc/ceph && \
    mkdir -p /var/lib/containers && \
    mkdir -p /var/lib/ceph && \
    mkdir -p /var/log/ceph && \
    (cd /root; rm -rf .ssh; ln -s /etc/ceph/ssh .ssh)

VOLUME /etc/ceph
VOLUME /var/lib/containers
VOLUME /var/lib/ceph
VOLUME /var/log/ceph
VOLUME /dev
 
COPY ./entrypoint.sh /
CMD ["/entrypoint.sh"]

