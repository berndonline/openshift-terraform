#!/usr/bin/env bash

set -x
exec > /var/log/user-data.log 2>&1

sudo su -

yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion httpd-tools
yum update -y

# Note: The step below is not in the official docs, I needed it to install
# Docker. If anyone finds out why, I'd love to know.
# See: https://forums.aws.amazon.com/thread.jspa?messageID=574126
yum-config-manager --enable rhui-REGION-rhel-server-extras

# Docker setup. Check the version with `docker version`, should be 1.12.
yum install -y docker

# Configure the Docker storage back end to prepare and use our EBS block device.
# https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
# Why xvdf? See:
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/xvdf
VG=docker-vg
EOF
docker-storage-setup

systemctl stop docker
rm -rf /var/lib/docker/*
systemctl restart docker

echo Defaults:ec2-user \!requiretty >> /etc/sudoers
