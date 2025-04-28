---
title: Use I3 on Arch Linux
date: 2020-01-13T12:17:55+08:00
tags:
  - i3WM
  - Linux
categories: Tools
---

> i3 is a tiling window manager, completely written from scratch. The target platforms are GNU/Linux and BSD operating systems, our code is Free and Open Source Software (FOSS) under the BSD license. i3 is primarily targeted at advanced users and developers.


# 0x00 i3 的安装与启动

安装 i3-gaps , i3-gaps 比 i3 有更多特性， 更加美观。

`sudo pacman -S i3-gaps`

因为我之前使用的桌面是 GNOME，所以可以直接使用 GDM(the GNOME Display Manger) 进行启动， 输入密码之后，在 `Sign in` 按钮旁边的小齿轮菜单中选择 i3 再登陆即可。

i3 的配置文件在 ~/.config/i3/config ,可以根据自己的喜好配置快捷键和自启动程序。

# 0x01 其他工具

- 终端 `sakura`
- 状态栏 `Polybar`
- 窗口管理器 `Compton`
- 程序启动器 `rofi`
- 输入法 `ibus-libpinyin` (因为未知原因无法识别到 fcitx 输入法)
- 桌面 `feh`
- 命令行网易云音乐 `musicbox`
- 蓝牙管理软件 `blueman`
- 网络管理软件 `nm-applet`
- 浏览器 `chromium`
- 文件管理器 `ranger`
- 锁屏软件 `i3lock-fancy-git`<sup>AUR<sup>

以上软件大部分都可以直接使用 pacman 包管理工具进行安装。部分软件需要设置自动运行，在 i3 的配置文件中进行修改即可。Polybar 参考[此配置](https://github.com/Dimerbone/dotfiles)，具体使用可以查看 Wiki 。
