#!/bin/sh
mkdir /data/mysql
chown -R mysql:mysql /data/mysql
service mysql stop
rsync -avzh /var/lib/mysql/ /data/mysql/
echo "alias /var/lib/mysql -> /data/mysql/," > /etc/apparmor.d/tunables/alias
awk '/Allow data dir access/{print $0 RS "/data/mysql/ r," RS "/data/mysql/** rwk,";next}1'  /etc/apparmor.d/usr.sbin.mysqld
systemctl restart apparmor.service
/etc/init.d/apparmor restart
#awk '/[mysqld]/{print $0 RS "datadir = /data/mysql";next}1'  /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '23i datadir = /data/mysql/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart
#Enabling Sysstat
apt install sysstat -y
sed -i 's/false/true/g' /etc/default/sysstat
service sysstat enable
service sysstat start
