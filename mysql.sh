#!bin/bash 

ORGANIZATION=DecodeDevOps
COMPONENT=mysql
DIRECTORY=/tmp/$COMPONENT

MYSQLREPO=https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm
MYSQLGPGKEY=https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

SHIPPINGDB=https://raw.githubusercontent.com/$ORGANIZATION/$COMPONENT/main/shippingdb.sql
CONFIGFILE=https://raw.githubusercontent.com/$ORGANIZATION/$COMPONENT/main/config.sql

OS=$(hostnamectl | grep 'Operating System' | tr ':', ' ' | awk '{print $3$NF}')
selinux=$(sestatus | awk '{print $NF}')

if [ $(id -u) -ne 0 ]; then
  echo -e "\e[1;33mYou need to run this as root user\e[0m"
  exit 1
fi

if [ $OS == "CentOS8" ]; then
    echo -e "\e[1;33mRunning on CentOS 8\e[0m"
    else
        echo -e "\e[1;33mOS Check not satisfied, Please user CentOS 8\e[0m"
        exit 1
fi

if [ $selinux == "disabled" ]; then
    echo -e "\e[1;33mSE Linux Disabled\e[0m"
    else
        echo -e "\e[1;33mOS Check not satisfied, Please disable SE linux\e[0m"
        exit 1
fi

hostname $COMPONENT

rpm -qa | grep mysql-community-server
if [ $? -ne 0 ]; then 
  yum list installed | grep mariadb
  yum remove mariadb-libs -y 
  echo -e "\e[1;33mInstalling MySQL community server :: \e[0m"
  yum install -y $MYSQLREPO
  yum repolist enabled | grep "mysql.*-community.*"
  yum module disable mysql -y
  rpm --import $MYSQLGPGKEY
  yum -y install mysql-community-server
  systemctl enable mysqld && systemctl start mysqld
  else
    echo -e "\e[1;33mMySQL existing installation found\e[0m"
fi

if [ -d "$DIRECTORY" ]; then
  echo -e "\e[1;33mCleanup $DIRECTORY directory\e[0m"
  rm -rf $DIRECTORY
  mkdir -p $DIRECTORY
  else
    echo -e "\e[1;33mcreating $DIRECTORY\e[0m"
    mkdir -p $DIRECTORY
fi

sleep 10

echo -e "\e[1;33mFollowing is the root password :: \e[0m"
SQLPassword=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
newPassword='RoboShop@1'

echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$newPassword';" | mysql --connect-expired-password -u root -p$SQLPassword
echo -e "\e[1;33mExisting Password:: $SQLPassword and New Password $newPassword\e[0m"

echo -e "\e[1;33mDisabling password hardening\e[0m"
echo -e "SET GLOBAL validate_password.length = 6" | mysql -u root -p$newPassword
echo -e "SET GLOBAL validate_password.number_count = 0" | mysql -u root -p$newPassword

echo -e "\e[1;33mDownloading and importing Shipping Database\e[0m"
curl -L $SHIPPINGDB -o $DIRECTORY/shippingdb.sql
curl -L $CONFIGFILE -o $DIRECTORY/configfile.sql

echo -e "\e[1;33mConfiguring and Importing config.sql :: \e[0m"
mysql -u root -p"$newPassword" < $DIRECTORY/configfile.sql

echo -e "\e[1;33mConfiguring and Importing shippingdb.sql :: \e[0m"
mysql -u root -p"$newPassword" < $DIRECTORY/shippingdb.sql

if [ $? -eq 0 ]; then
    echo -e "\e[1;33m$COMPONENT configured successfully\e[0m"
    else
        echo -e "\e[1;33mfailed to configure $COMPONENT\e[0m"
        exit 0
fi

#select user from mysql.user;