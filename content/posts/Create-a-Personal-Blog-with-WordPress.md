---
title: Create a Personal Blog with WordPress
date: 2019-02-17T10:16:11+08:00
tags:
  - WorldPress
categories: Tools
---

#### 前期准备

- 一台 vps
- 一枚域名

我使用的是 Digital Ocean 的 vps，ubuntu 16.04（github 学生包送了 50 刀），以及 namecheap 的一个 .me 的域名（也是 github 学生包送的）。

#### 用 xshell 连接 vps

#### 安装 Apache

```shell
$ sudo apt-get update
$ sudo apt-get install apache2
$ sudo vim /etc/apache/apache2.conf
```

在 apache2.conf 中添加以下语句(server_ip 为你的服务器 ip)
`ServerName server_ip`

重启 apache
`$ sudo systemctl restart apache2`

设置防火墙
`$ sudo ufw allow in "Apache Full"`

#### 安装 MySql

```shell
$ sudo apt-get install myslq-server
$ mysql_secure_installation
```

密码强度选哪个都可以，但是之后建数据库的时候要根据你选择的密码强度设定密码。

#### 安装 php

`$ sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql`

创建数据库
执行以下命令以用户名 root 登录，然后输入密码
`$ mysql -u root -p`

建立名为 wordpress 的数据库(user_name/user_password 自己设置，密码要符合之前选择的密码强度)

```sql
mysql> create database wordpress default character set utf8 collate utf8_unicode_ci;
myslq> grant all on wordpress.* to 'user_name'@'localhost' identified by 'user_password';
mysql> flush privileges;
myslq> exit;
```

安装 php 拓展并重启 apache 服务

```shell
$ sudo apt-get update
$ sudo apt-get install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
$ sudo systemctl restart apache2
```

#### 调整 Apache 配置

`$ sudo vim /etc/apache2/apache2.conf`

添加下列语句语句

```html
<Directory /var/www/html>
    AllowOverride All
</Directory>
```

执行如下命令以使用 Wordpress 的永久链接功能
`.$ sudo a2enmod rewrite`

重启 apache 服务
`$ sudo systemctl restart apache2`

#### 下载 wordpress

```shell
$ cd /tmp
$ curl -O https://wordpress.org/latest.tar.gz
$ tar xzvf latest.tar.gz
```

创建 .htaccess 文件

```shell
$ touch /tmp/wordpress/.htaccess
$ chmod 660 /tmp/wordpress/.htaccess
```

配置文件目录

```shell
$ cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
$ mkdir /tmp/wordpress/wp-content/upgrade
$ sudo cp -a /tmp/wordpress/. /var/www/html
```

#### 配置 wordpress

设置用户

```shell
$ sudo chown -R www-data:www-data /var/www/html
$ sudo find /var/www/html -type d -exec chmod g+s {} \;
$ sudo chmod g+w /var/www/html/wp-content
$ sudo chmod -R g+w /var/www/html/wp-content/themes
$ sudo chmod -R g+w /var/www/html/wp-content/plugins
```

配置 wordpress 配置文件
`$ curl -s https://api.wordpress.org/secret-key/1.1/salt/`

复制输出的内容并替换掉配置文件中的部分
`$ vim /var/www/html/wp-config.php`

同时修改以下语句

```shell
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'user_name');

/** MySQL database password */
define('DB_PASSWORD', 'user_password');
```

添加
`define('FS_METHOD', 'direct');`

#### 完成

将到域名管理界面将域名解析到服务器的 ip 地址，访问你的域名或 ip

> **参考** 
> [https://www.jianshu.com/p/12d917f96a0d](https://www.jianshu.com/p/12d917f96a0d) 
> [https://www.jianshu.com/p/706ed7486b01](https://www.jianshu.com/p/706ed7486b01)
