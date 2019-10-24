#!/usr/bin/bash

# Update and upgade OS and kernel on CentOS 7 KMV server
yum -y update
yum -y upgrade

# kernel upgrade to 5.1 >

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml

sed -i -e 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/g' /etc/default/grub

grub2-mkonfig -o /boot/grub2/grub.cfg

reboot
