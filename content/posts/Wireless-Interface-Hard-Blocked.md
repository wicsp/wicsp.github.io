---
title: Wireless Interface Hard-Blocked
date: 2019-02-17T10:30:33+08:00
tags:
  - Linux
categories:
  - Tools
---

> 安装 networkmanager 后执行 `$ nmcli dev` , 发现无线网卡 `wlp3s0` 的状态为 `unavailable`

<!-- more -->

执行命令 `$ sudo rekill list` 发现无线网卡状态为

```
 soft blocked   no
 hard blocked   yes
```

# 查找资料后发现这是由于硬件开关未打开导致的。但是现在笔记本电脑上并没有网卡开关，因此直接禁用联想的无线模块即可

- 在黑名单中加入 ideapad_laptop

  `$ sudo vim /etc/modprobe.d/ideapad.conf`

  在第一行加入

  `blacklist ideapad_laptop`

  保存并退出

- 执行 `$ sudo modprobe -r ideapad_laptop`

  这时键盘可能会失效，直接按关机键重启即可

- 重启后再次执行 `$ rekill list` 显示为
  ```
    soft blocked   no
    hard blocked   no
  ```

这时就可以使用无线网卡了
