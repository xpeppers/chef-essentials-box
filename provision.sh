#!/bin/sh

set -e

mv /etc/yum.conf /etc/yum.conf.disabled
echo '' > /etc/yum.conf

yum install -y yum-utils epel-release kernel-devel kernel-headers dkms tree git nano vim emacs httpd ntp ntpdate php perl
yum groupinstall -y "Development Tools"

/sbin/sysctl -w net.ipv4.ip_forward=1

sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT 5 -i eth0 -p tcp --dport 8000 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT 5 -i eth0 -p tcp --dport 8080 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT 5 -i eth0 -p tcp --dport 8081 -m state --state NEW,ESTABLISHED -j ACCEPT
