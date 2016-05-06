#!/bin/sh

set -e

mv /etc/yum.conf /etc/yum.conf.disabled
echo '' > /etc/yum.conf

yum install -y yum-utils epel-release kernel-devel kernel-headers dkms tree git nano vim emacs httpd ntp ntpdate php perl
yum groupinstall -y "Development Tools"
yum install -y xorg-x11-drv-evdev xorg-x11-drv-keyboard xorg-x11-drv-mouse xorg-x11-fonts-100dpi \
  xorg-x11-server-Xorg xorg-x11-server-common xorg-x11-server-utils xorg-x11-xinit openbox Terminal

/sbin/sysctl -w net.ipv4.ip_forward=1
service docker restart

usermod -a -G docker vagrant
usermod -a -G vboxsf vagrant

echo "xrandr --output VGA-0 --auto --primary --mode 1024x768" > /home/vagrant/.xprofile
echo "exec openbox-session" > /home/vagrant/.xinitrc
echo 'startx' > /home/vagrant/.bash_profile
mkdir -p  /home/vagrant/.config/openbox
echo 'VBoxClient --clipboard; setxkbmap it; terminal &' > /home/vagrant/.config/openbox/autostart
echo 'sudo mount -t vboxsf -o uid=500,gid=500 $1 $2' > /home/vagrant/mount-share.sh
chmod 755 /home/vagrant/mount-share.sh
chown -R vagrant:vagrant /home/vagrant

cd /vagrant
docker rmi -f $(docker images -q)
docker build -t xpeppers/chef-training ./

yum clean all
mv /etc/yum.repos.d /etc/yum.repos.d.disabled

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
