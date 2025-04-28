---
title: Add Sudo Quickly
date: 2020-01-21 12:21:44
tags:
  - Linux
  - Tips
categories: Tools
---

因为我使用ArchLinux，使用Pacman更新时常常遇到需要在命令前加sudo的情况，每次都需要把光标移到命令首部加 sudo ，经查找可以使用 `sudo !!` 获取前一条命令并加上 sudo 。

如运行 `pacman -Syu` 报错，使用 `sudo !!` 生成 `sudo pacman -Syu` 回车即可。

或者使用 `thefuck` ，不仅可以补全 sudo ，也可以更正输入错误的命令。（不知道为什么使用 `thefuck` 反应速度很慢。。。）
