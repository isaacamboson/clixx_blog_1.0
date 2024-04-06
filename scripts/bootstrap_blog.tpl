#!/bin/bash

sudo su - 

# partitioning disk - sdb (xvdb)
fdisk /dev/sdb <<EEOF
p
n
p
1
2048
20971519
p
w
EEOF
fdisk /dev/sdc <<EEOF
p
n
p
1
2048
20971519
p
w
EEOF
fdisk /dev/sdd <<EEOF
p
n
p
1
2048
20971519
p
w
EEOF
fdisk /dev/sde <<EEOF
p
n
p
1
2048
20971519
p
w
EEOF
fdisk /dev/sdf <<EEOF
p
n
p
1
2048
20971519
p
w
EEOF

# creating the disk labels (physical volume)
pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

# creating volume group 
vgcreate stack_vg /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

# listing volume group(s)
vgs

# creating new logical volumes (LUNs) from volume groups with 8GB of space allocated initially
lvcreate -L 8G -n Lv_u01 stack_vg
lvcreate -L 8G -n Lv_u02 stack_vg
lvcreate -L 8G -n Lv_u03 stack_vg
lvcreate -L 8G -n Lv_u04 stack_vg
lvcreate -L 8G -n Lv_backup stack_vg

# listing volumes 
lvs

# creating ext4 filesystems on the logical volumes
mkfs.ext4 /dev/stack_vg/Lv_u01
mkfs.ext4 /dev/stack_vg/Lv_u02
mkfs.ext4 /dev/stack_vg/Lv_u03
mkfs.ext4 /dev/stack_vg/Lv_u04
mkfs.ext4 /dev/stack_vg/Lv_backup

# creating mount points that will hold the space for logical volumes
mkdir /u01
mkdir /u02
mkdir /u03
mkdir /u04
mkdir /backup

# mounting the volumes on the mount points
mount /dev/stack_vg/Lv_u01 /u01
mount /dev/stack_vg/Lv_u02 /u02
mount /dev/stack_vg/Lv_u03 /u03
mount /dev/stack_vg/Lv_u04 /u04
mount /dev/stack_vg/Lv_backup /backup

# extending the logical volumes by 2GB of space 
lvextend -L +2G /dev/mapper/stack_vg-Lv_u01
lvextend -L +2G /dev/mapper/stack_vg-Lv_u02
lvextend -L +2G /dev/mapper/stack_vg-Lv_u03
lvextend -L +2G /dev/mapper/stack_vg-Lv_u04
lvextend -L +1G /dev/mapper/stack_vg-Lv_backup

# resize gets reflected after running command below
resize2fs /dev/mapper/stack_vg-Lv_u01
resize2fs /dev/mapper/stack_vg-Lv_u02
resize2fs /dev/mapper/stack_vg-Lv_u03
resize2fs /dev/mapper/stack_vg-Lv_u04
resize2fs /dev/mapper/stack_vg-Lv_backup

echo "/dev/mapper/stack_vg-Lv_u01 /u01 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_u02 /u02 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_u03 /u03 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_u04 /u04 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_backup /backup ext4 defaults 1 2" >> "/etc/fstab"

ls -ltr

#sudo su -
sudo yum update -y
sudo yum install -y nfs-utils
FILE_SYSTEM_ID=${efs_id_blog}

#EFS CREATION AND MOUNTING
TOKEN=$(curl --request PUT "http://169.254.169.254/latest/api/token" --header "X-aws-ec2-metadata-token-ttl-seconds: 3600")
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region --header "X-aws-ec2-metadata-token: $TOKEN")
MOUNT_POINT=/var/www/html
mkdir -p $MOUNT_POINT
chown ec2-user:ec2-user $MOUNT_POINT
echo $FILE_SYSTEM_ID.efs.$REGION.amazonaws.com:/ $MOUNT_POINT nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
mount -a -t nfs4
chmod -R 755 /var/www/html


# #installing updates without confirmation
# #sudo yum update -y

# #installing the latest versions of the LAMP MariaDB and PHP packages for Amazon Linux 2
# sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
# sudo yum install -y httpd mariadb-server

# #starting and enabling Apache server
# sudo systemctl start httpd
# sudo systemctl enable httpd

# #verifying that Apache httpd is on 
# sudo systemctl is-enabled httpd

# #adding ec2-user to apache group to Modify ownership and permission
# sudo usermod -a -G apache ec2-user

# #verifying membership in the "Apache" group
# groups

# #changing the group ownership of /var/www and its content to the "Apache" group
# #adding group write permissions and to set the group ID on future subdirectories, 
# #change the directory permissions of /var/www and its subdirectories.
# sudo chown -R ec2-user:apache /var/www
# sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;

# #adding group write permissions, recursively change the file permissions of /var/www and its subdirectories:
# find /var/www -type f -exec sudo chmod 0664 {} \;

#installing PHP Admin
sudo yum install php-mbstring -y

sudo systemctl restart httpd
sudo systemctl restart php-fpm

#installing git
cd /var/www/html
# sudo yum install git -y

sudo mkdir installation
cd installation
sudo git clone ${GIT_REPO_BLOG}
# sudo git clone https://github.com/isaacamboson/my_stack_blog.git
cp -rf my_stack_blog/* /var/www/html

#creating database user and database for WordPress installation:
db_name=${rds_mysql_db_blog}
db_user=${rds_mysql_usr_blog}
db_password=${rds_mysql_pwd_blog}
rds_instance=${rds_mysql_ept_blog}
db_email="isaacamboson@gmail.com"

wp_config=/var/www/html/wp-config.php

sed -i "s/'database_name_here'/'$db_name'/g" $wp_config
sed -i "s/'username_here'/'$db_user'/g" $wp_config
sed -i "s/'password_here'/'$db_password'/g" $wp_config
sed -i "s/'rds_instance_here'/'$rds_instance'/g" $wp_config

load_balancer_dns=${LB_DNS_BLOG}

mysql -h $rds_instance -u $db_user -p$db_password -D $db_name <<EOF
UPDATE wp_options SET option_value = "$load_balancer_dns" WHERE option_id = '1';
UPDATE wp_options SET option_value = "$load_balancer_dns" WHERE option_id = '2';
EOF

#restart apache http server and enable services
sudo systemctl restart httpd
sudo systemctl enable httpd && sudo systemctl enable mariadb

#sudo systemctl status of MySQL and apache HTTP server
sudo systemctl status mariadb
sudo systemctl status httpd

# Restart Apache to make sure all changes take effect
sudo systemctl restart httpd





