---
title: Recover Removed Files on Linux
date: 2020-01-22T22:01:47+08:00
tags:
  - Linux
categories:
  - Tools
---

# 0x00 确定删除文件所在分区

```sh
df <被删除文件所在文件夹>
```

<!-- more -->

# 0x01 进入 debugfs 工具

```sh
debugfs
```
(如果是不是 root 用户需要在命令前加 sudo)

# 0x02 在 debugfs 工具中打开文件分区并列出删除文件

```
debugfs: open <0x00 中返回的分区如 /dev/sda1>
debugfs: ls -d <被删除文件所在目录>
```

返回类似 “<12345678> (20) filename”

# 0x03 找到被删除文件所在的位置

`debugfs: logdump –i  <12345678>`

返回内容类似

```
Inode 12345678 is at group 1040, block 34078863, offset 1664
Journal starts at block 65638, transaction 1209216
Found sequence 1200142 (not 1209605) at block 72380: end of journal.
```

记住 block 和 offset 的值

# 0x04 恢复文件

`$ sudo dd if=<文件所在分区> of=<文件所在文件夹> bs=<offset 的值> count=1 skip=<block 的值>`

# 后续

这种方法的优点是不需要安装额外的软件，虽然比较繁琐但只需要恢复少量文件的话还是可以接受的。用这种方法不能否还原目录，下次有需要再尝试。

> 参考自[本博文](https://www.cnblogs.com/jiftle/p/10966636.html)
