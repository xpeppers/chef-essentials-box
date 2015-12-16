#!/bin/sh

yum install -y dkms gcc kernel-devel kernel-headers tree git nano vim emacs httpd
service vboxadd setup

/sbin/sysctl -w net.ipv4.ip_forward=1
service docker restart

cd /vagrant/docker
docker rmi $(docker images -q)
docker build -t xpeppers/chef-essentials ./

yum clean all

cat /dev/null > ~/.bash_history && history -c

#sudo dd if=/dev/zero of=/EMPTY bs=1M
#sudo rm -f /EMPTY
