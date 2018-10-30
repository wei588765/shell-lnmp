# Designed by HCWEI
# DATE: 2018-10-23 17:45:00
# Github: https://github.com/wei588765/shell-lnmp.git

本实例使用shell脚本一键部署LNMP环境，并配置本地redis。

软件版本：
nginx-1.14.0
mysql-5.7.23
php-7.2.8
redis-4.0.11

使用方法：
拉取本实例代码及软件：
git clone https://github.com/wei588765/shell-lnmp.git

讲文件夹改名为tools并放到根目录：
mv shell-lnmp /tools

进入scripts文件夹并运行lnmp.sh，根据需求安装相应软件：
cd /tools/scripts && sh lnmp.sh


注意：如果yum安装了mariadb需要先卸载
yum remove -y mariadb*
