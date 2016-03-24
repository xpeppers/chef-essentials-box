#!/bin/sh

set -e

echo '' > /etc/yum.conf

yum install -y yum-utils epel-release kernel-devel kernel-headers dkms tree git nano vim emacs httpd
yum groupinstall -y "Development Tools"
yum install -y xorg-x11-drv-evdev xorg-x11-drv-keyboard xorg-x11-drv-mouse xorg-x11-fonts-100dpi \
  xorg-x11-server-Xorg xorg-x11-server-common xorg-x11-server-utils xorg-x11-xinit openbox Terminal

/sbin/sysctl -w net.ipv4.ip_forward=1
service docker restart

usermod -a -G docker vagrant
usermod -a -G vboxsf vagrant

echo "xrandr --output VGA-0 --auto --primary --mode 1024x768" > /home/vagrant/.xprofile
echo "exec openbox-session" > /home/vagrant/.xinitrc
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' > /home/vagrant/.bash_profile
mkdir -p  /home/vagrant/.config/openbox
echo 'setxkbmap it && terminal &' > /home/vagrant/.config/openbox/autostart
chown -R vagrant:vagrant /home/vagrant

cd /vagrant
docker rmi -f $(docker images -q)
docker build -t xpeppers/chef-essentials ./

yum clean all
mv /etc/yum.repos.d /etc/yum.repos.disabled

cd /
umount /vagrant

find /var/log -type f | while read f; do echo -ne '' > $f; done;
rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest* /usr/src/virtualbox-guest*
rm -rf /usr/src/linux-headers*

unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

set +e

count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;

count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
