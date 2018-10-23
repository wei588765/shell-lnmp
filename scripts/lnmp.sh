#!/bin/bash
##选择要按照的内容
echo "please choose server which need to install"
read -p "install nginx(y/n):" n
read -p "install mysql(y/n):" m
read -p "install php(y/n):" p
##环境配置
yum install -y make cmake gcc gcc-c++ autoconf automake libpng-devel libjpeg-devel zlib libxml2-devel ncurses-devel bison libtool-ltdl-devel libiconv libmcrypt mhashmcrypt libmcrypt-devel pcre-devel openssl-devel freetype-devel libcurl-devel
if [ $? != 0 ];then exit 1;fi
cd /tools/package/
tar xf boost_1_59_0.tar.gz
mv boost_1_59_0 /usr/local/boost_1_59_0
ln -s /usr/local/boost_1_59_0 /usr/local/boost

##安装nginx
pkill nginx
if [ $n == "y" ]
then 
cd /tools/package
if [ -d nginx-1.14.0 ];then rm -rf /tools/package/nginx-1.14.0;fi
tar xf nginx-1.14.0.tar.gz
cd /tools/package/nginx-1.14.0
useradd -s /sbin/nologin -M www
./configure --user=www --group=www --prefix=/usr/local/nginx-1.14.0 --with-http_ssl_module --with-http_stub_status_module
if [ $? != 0 ];then exit 1;fi
make -j 4
if [ $? != 0 ];then exit 1;fi
make install
if [ $? != 0 ];then exit 1;fi
chown -R www.www /usr/local/nginx-1.14.0
ln -s /usr/local/nginx-1.14.0 /usr/local/nginx
cd /usr/local/sbin
if [ -f nginx ];then rm -rf /usr/local/sbin/nginx;fi
ln -s /usr/local/nginx-1.14.0/sbin/nginx /usr/local/sbin/nginx
chmod +x /usr/local/sbin/nginx
nginx
echo -e "[Unit]\nDescription=nginx\nAfter=network.target\n[Service]\nType=forking\nExecStart=/usr/local/nginx/sbin/nginx\nExecReload=/usr/local/nginx/sbin/nginx reload\nExecStop=/usr/local/nginx/sbin/nginx quit\nPrivateTmp=true\n[Install]\nWantedBy=multi-user.target" > /lib/systemd/system/nginx.service
systemctl enable nginx.service
else
echo "nginx don't install!!!"
fi

##安装mysql
pkill mysql
if [ $m == "y" ]
then
useradd -s /sbin/nologin -M mysql
cd /tools/package/
if [ -d mysql-5.7.23 ];then rm -rf /tools/package/mysql-5.7.23;fi
tar xf mysql-5.7.23.tar.gz
cd mysql-5.7.23
rm -rf CMakeCache.txt
cmake  -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.7.23  -DMYSQL_DATADIR=/usr/local/mysql-5.7.23/data  -DMYSQL_UNIX_ADDR=/tmp/mysql.sock  -DDEFAULT_CHARSET=utf8  -DDEFAULT_COLLATION=utf8_general_ci  -DWITH_BOOST=/usr/local/boost
if [ $? != 0 ];then exit 1;fi
make -j 4
if [ $? != 0 ];then exit 1;fi
make install
if [ $? != 0 ];then exit 1;fi
chown -R mysql.mysql /usr/local/mysql-5.7.23
ln -s /usr/local/mysql-5.7.23 /usr/local/mysql
/usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data 
echo "PATH="/usr/local/mysql/bin:$PATH"" >>/etc/profile
sed -i "s#var/lib#usr/local#g" /etc/my.cnf
ln -s /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
ln -s /usr/local/mysql/bin/mysql /usr/local/sbin/mysql
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
/usr/local/mysql/support-files/mysql.server start
else
 echo "mysql don't install!!!"
fi

##安装php
pkill php
if [ $p == "y" ]
then
cd /tools/package
if [ -d php-7.2.8 ];then rm -rf /tools/package/php-7.2.8;fi
tar xf php-7.2.8.tar.bz2 
cd php-7.2.8
useradd -s /sbin/nologin -M www
./configure --prefix=/usr/local/php-7.2.8 --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir --enable-simplexml --enable-xml --disable-rpath --enable-bcmath --enable-soap --enable-zip --with-curl --enable-fpm --with-fpm-user=www --with-fpm-group=www --enable-mbstring --enable-sockets --with-gd --with-openssl --with-mhash --enable-opcache --disable-fileinfo
if [ $? != 0 ];then exit 1;fi
make -j 4
if [ $? != 0 ];then exit 1;fi
make install
if [ $? != 0 ];then exit 1;fi
cp php.ini-development /usr/local/php-7.2.8/lib/php.ini
cd /usr/local/php-7.2.8/etc/
cp php-fpm.conf.default php-fpm.conf
chown -R www.www /usr/local/php-7.2.8
ln -s /usr/local/php-7.2.8 /usr/local/php
cd /usr/local/php-7.2.8/etc/php-fpm.d && cp www.conf.default www.conf
cd /usr/local/sbin
if [ -f php-fpm ];then rm -rf /usr/local/sbin/php-fpm;fi
ln -s /usr/local/php-7.2.8/sbin/php-fpm /usr/local/sbin/php-fpm
ln -s /usr/local/php-7.2.8/sbin/php-fpm /etc/init.d/php-fpm
chmod 755 /etc/init.d/php-fpm
systemctl enable php-fpm
chmod +x /usr/local/sbin/php-fpm
php-fpm
else
 echo "php don't install!!!"
fi
