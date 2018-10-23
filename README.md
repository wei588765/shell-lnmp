# Designed by HCWEI
# DATE: 2018-10-23 17:45:00
# Github: https://github.com/wei588765/shell-lnmp.git

本实例使用shell脚本一键部署LNMP环境。

软件版本：
nginx-1.14.0
mysql-5.7.23
php-7.2.8

安装方法：
服务器根下创建tools目录
mkdir /tools

拉取本实例代码及软件
git clone https://github.com/wei588765/shell-lnmp.git

进入scripts文件夹并运行lnmp.sh
cd /tools/scripts && sh lnmp.sh

选择需要安装的软件即可。

注意：如果yum安装了mariadb需要先卸载
yum remove -y mariadb*
