---
title: "aria2"
date: "2019-03-27T11:14:46+08:00"
tags: ["Tools"]
categories: ["Tools"]
draft: true
---

> 转自[Aria2打造属于自己的下载神器](https://juejin.im/post/5b20006f5188257d831e3dd0)

我使用Aria2差不多已经2年了。在这段时间使用很多下载工具，最开始使用的是迅雷极速版 、后面各种原因不好使了。`Free Download Manager`、`uTorrent`、`qBittorrent`、`BitComet`、`IDM`等等全部折腾了一遍。各有千秋，在上面中使用下载种子和磁链最好用的是`qBittorrent`。http下载最好用的`IDM`。`qBittorrent`下载http有限制，`IDM`不能下载种子并是收费软件。

 Aria2简介
--------

官网地址：[Aria2官网](https://link.juejin.im?target=https%3A%2F%2Flink.jianshu.com%2F%3Ft%3Dhttps%3A%2F%2Faria2.github.io%2F)

> Aria2是一个命令行下**轻量级**、多协议、多来源的**下载工具**（支持 **HTTP/HTTPS、FTP、BitTorrent**、**Metalink**），内建 **XML-RPC** 和 **JSON-RPC** 用户界面。

 安装与配置
------

本着要使用`Aria2`,就需要有折腾的心。不乏有部分盆友不是没有折腾心，而是已经绝望了。好吗我就在这里提供详细的方法。

1. 下载最新的[`Aria2`](https://link.juejin.im?target=https%3A%2F%2Faria2.github.io%2F) ，到你电脑的英文路径下（这里比如在D:\\aria2\ ）这里有aria2c 可执行文件，最新64位版本的Aria2
```
aria2/
├── aria2c.exe
├── AUTHORS
├── ChangeLog
├── COPYING
├── LICENSE.OpenSSL
├── NEWS
├── README.html
└── README.mingw
```

2. 在D:\\aria2\ 下新建几个文件
    
* `aria2.log` （日志，空文件就行）
* `aria2.session` （下载历史，空文件就行）
* `aria2.conf` （配置文件）
* `HideRun.vbs` （隐藏cmd窗口运行用到的）
    
```
aria2/
├── aria2.conf
├── aria2.log
├── aria2.session
├── aria2c.exe
├── AUTHORS
├── ChangeLog
├── COPYING
├── HideRun.vbs
├── LICENSE.OpenSSL
├── NEWS
├── README.html
└── README.mingw
```
    
3. 配置aria2.conf
```    
## '#'开头为注释内容, 选项都有相应的注释说明, 根据需要修改 ##
## 被注释的选项填写的是默认值, 建议在需要修改时再取消注释  ##

## 文件保存相关 ##

# 文件的保存路径(可使用绝对路径或相对路径), 默认: 当前启动位置（自己设置）
dir=D:\aria2\downloads
# 启用磁盘缓存, 0为禁用缓存, 需1.16以上版本, 默认:16M
#disk-cache=32M
# 文件预分配方式, 能有效降低磁盘碎片, 默认:prealloc
# 预分配所需时间: none < falloc ? trunc < prealloc
# falloc和trunc则需要文件系统和内核支持
# NTFS建议使用falloc, EXT3/4建议trunc, MAC 下需要注释此项
#file-allocation=none
# 断点续传
continue=true

## 下载连接相关 ##

# 最大同时下载任务数, 运行时可修改, 默认:5 （自己设置）
#max-concurrent-downloads=5
# 同一服务器连接数, 添加时可指定, 默认:1 （自己设置）
max-connection-per-server=5
# 最小文件分片大小, 添加时可指定, 取值范围1M -1024M, 默认:20M
# 假定size=10M, 文件为20MiB 则使用两个来源下载; 文件为15MiB 则使用一个来源下载 （自己设置）
min-split-size=10M
# 单个任务最大线程数, 添加时可指定, 默认:5 （自己设置）
#split=5
# 整体下载速度限制, 运行时可修改, 默认:0
#max-overall-download-limit=0
# 单个任务下载速度限制, 默认:0
#max-download-limit=0
# 整体上传速度限制, 运行时可修改, 默认:0
#max-overall-upload-limit=0bv
# 单个任务上传速度限制, 默认:0
#max-upload-limit=0
# 禁用IPv6, 默认:false
#disable-ipv6=true
# 连接超时时间, 默认:60
#timeout=60
# 最大重试次数, 设置为0表示不限制重试次数, 默认:5
#max-tries=5
# 设置重试等待的秒数, 默认:0
#retry-wait=0

## 进度保存相关 ##

# 从会话文件中读取下载任务（自己设置）
input-file=D:\aria2\aria2.session
# 在Aria2退出时保存`错误/未完成`的下载任务到会话文件（自己设置）
save-session=D:\aria2\aria2.session
# 定时保存会话, 0为退出时才保存, 需1.16.1以上版本, 默认:0
#save-session-interval=60

## RPC相关设置 ##

# 启用RPC, 默认:false
enable-rpc=true
# 允许所有来源, 默认:false
rpc-allow-origin-all=true
# 允许非外部访问, 默认:false
rpc-listen-all=true
# 事件轮询方式, 取值:[epoll, kqueue, port, poll, select], 不同系统默认值不同
#event-poll=select
# RPC监听端口, 端口被占用时可以修改, 默认:6800
#rpc-listen-port=6800
# 设置的RPC授权令牌, v1.18.4新增功能, 取代 --rpc-user 和 --rpc-passwd 选项
#rpc-secret=<TOKEN>
# 设置的RPC访问用户名, 此选项新版已废弃, 建议改用 --rpc-secret 选项
#rpc-user=<USER>
# 设置的RPC访问密码, 此选项新版已废弃, 建议改用 --rpc-secret 选项
#rpc-passwd=<PASSWD>
# 是否启用 RPC 服务的 SSL/TLS 加密,
# 启用加密后 RPC 服务需要使用 https 或者 wss 协议连接
#rpc-secure=true
# 在 RPC 服务中启用 SSL/TLS 加密时的证书文件,
# 使用 PEM 格式时，您必须通过 --rpc-private-key 指定私钥
#rpc-certificate=/path/to/certificate.pem
# 在 RPC 服务中启用 SSL/TLS 加密时的私钥文件
#rpc-private-key=/path/to/certificate.key

## BT/PT下载相关 ##

# 当下载的是一个种子(以.torrent结尾)时, 自动开始BT任务, 默认:true
#follow-torrent=true
# BT监听端口, 当端口被屏蔽时使用, 默认:6881-6999
listen-port=51413
# 单个种子最大连接数, 默认:55
#bt-max-peers=55
# 打开DHT功能, PT需要禁用, 默认:true
enable-dht=false
# 打开IPv6 DHT功能, PT需要禁用
#enable-dht6=false
# DHT网络监听端口, 默认:6881-6999
#dht-listen-port=6881-6999
# 本地节点查找, PT需要禁用, 默认:false
#bt-enable-lpd=false
# 种子交换, PT需要禁用, 默认:true
enable-peer-exchange=false
# 每个种子限速, 对少种的PT很有用, 默认:50K
#bt-request-peer-speed-limit=50K
# 客户端伪装, PT需要
peer-id-prefix=-TR2770-
user-agent=Transmission/2.77
# 当种子的分享率达到这个数时, 自动停止做种, 0为一直做种, 默认:1.0
seed-ratio=0
# 强制保存会话, 即使任务已经完成, 默认:false
# 较新的版本开启后会在任务完成后依然保留.aria2文件
#force-save=false
# BT校验相关, 默认:true
#bt-hash-check-seed=true
# 继续之前的BT任务时, 无需再次校验, 默认:false
bt-seed-unverified=true
# 保存磁力链接元数据为种子文件(.torrent文件), 默认:false
bt-save-metadata=true
```

《[Aria2 & YAAW 使用说明](https://link.juejin.im?target=http%253A%2F%2Faria2c.com%2Fusage.html)》**`#`号代表注释内容，删除了#号的注释项才会生效。**

配置（自己设置）都是需要根据自己的情况修改，更多更详尽的配置项请参考官方 [manual](https://link.juejin.im?target=https%3A%2F%2Faria2.github.io%2Fmanual%2Fen%2Fhtml%2Faria2c.html%23options)

4. 编辑HideRun.vbs，并复制以下内容，注意修改D:\\Aria2\\为你的aria2安装路径
```
CreateObject("WScript.Shell").Run "D:\Aria2\aria2c.exe --conf-path=aria2.conf",0
```
    
要点击这个文件`HideRun.vbs`，不要点击aria2c.exe。如果要开机启动，创建一个HideRun.vbs的快捷方式，放在”C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp“中即可
    

 管理Aria 2下载
-----------

如果上面的安装和修改配置都完成了并保证**aria2在运行** ，那么我们就可以使用命令行下载了。但是我这里不想介绍怎么使用命令行。介绍我使用的`GUI`方法。

1.  在window下面的客服端我使用的是 [`AriaNg`](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fmayswind%2FAriaNg%2Freleases),这是一个网页版本，但是我自己打包成`exe`可执行文件了。有需要的可以关注我的微信公众号（👉sharingplus），可执行文件有点大，下面都是使用的Web 前端控制。
    
    *   [webui-aria2](https://link.juejin.im?target=http%3A%2F%2Fziahamza.github.io%2Fwebui-aria2%2F)  
        点击👆，可以可以看到如下图：
        
        ![Snipaste_2018-06-12_14-35-10.png](https://user-gold-cdn.xitu.io/2018/6/13/163f50172455f9a1?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
        
        ![68747470733a2f2f63646e2e7261776769742e636f6d2f6a61652d6a61652f5f7265736f75726365732f6d61737465722f78787865333333332e706e67.png](https://user-gold-cdn.xitu.io/2018/6/13/163f5017979d5f57?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
        
    *   [YAAW](https://link.juejin.im?target=http%3A%2F%2Fbinux.github.io%2Fyaaw%2Fdemo%2F)  
        点击👆，可以可以看到如下图：
        
        ![Snipaste_2018-06-12_14-39-13.png](https://user-gold-cdn.xitu.io/2018/6/13/163f50175f105de4?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
        
        ![Snipaste_2018-06-12_14-39-39.png](https://user-gold-cdn.xitu.io/2018/6/13/163f501730f4ebfc?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
        
    *   [Aria2-GUI](https://link.juejin.im?target=http%3A%2F%2Fwapznw.gitee.io%2Faria2desktop%2F)  
        点击👆，可以可以看到如下图：
        
        ![Snipaste_2018-06-13_00-05-48.png](https://user-gold-cdn.xitu.io/2018/6/13/163f5017a4df6bb2?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
        
    *   [AriaNg](https://link.juejin.im?target=http%3A%2F%2Fariang.mayswind.net%2Flatest%2F%23!%2Fdownloading)  
        点击👆，可以可以看到如下图：
        
        ![Snipaste_2018-06-13_00-03-19.png](https://user-gold-cdn.xitu.io/2018/6/13/163f50172c4750ec?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
        
        ![Snipaste_2018-06-13_00-04-11.png](https://user-gold-cdn.xitu.io/2018/6/13/163f50182e2522d2?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
        
    
    平时使用浏览器下载时候，是不是简直不能忍`chrome`下载速度，后来发现一款神器可以完美使用`Aria2`替换chrome的默认下载。使用`friefox`、`Safari`浏览器不要灰心，同样的有这样的插件。
    
    *   [Chrome](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fjae-jae%2Fcamtd)
        
        *   [Chrome Webstore](https://link.juejin.im?target=https%3A%2F%2Fchrome.google.com%2Fwebstore%2Fdetail%2Fcamtd-aria2-download-mana%2Flcfobgbcebdnnppciffalfndpdfeence%3Futm_source%3Dchrome-ntp-icon)
            
        *   从[Github releases](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fjae-jae%2FCamtd%2Freleases) 获取crx文件
            
        *   第一处配置：
            
            ![68747470733a2f2f63646e2e7261776769742e636f6d2f6a61652d6a61652f5f7265736f75726365732f6d61737465722f64666173646664663233322e706e67.png](https://user-gold-cdn.xitu.io/2018/6/13/163f501832bd9360?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
            
        *   第二处配置：
            
            ![68747470733a2f2f63646e2e7261776769742e636f6d2f6a61652d6a61652f5f7265736f75726365732f6d61737465722f78787865333333332e706e67.png](https://user-gold-cdn.xitu.io/2018/6/13/163f5017979d5f57?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
            
        
        一切准备就绪后，就可以使用Camtd了，Camtd默认的配置应该就可以正常工作了，如果工作不正常，请检查2个地方的配置，看下图演示,主要是要正确配置Aria2的RPC链接地址：
        
        ![68747470733a2f2f63646e2e7261776769742e636f6d2f6a61652d6a61652f5f7265736f75726365732f6d61737465722f73657474696e672e676966.gif](https://user-gold-cdn.xitu.io/2018/6/13/163f50185371e0b7?imageslim)
        
    *   [Friefox](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2FRossWang%2FAria2-Integration)
        
        *   从FrieFox Webstore获取：[addons.mozilla.org/zh-CN/firef…](https://link.juejin.im?target=https%3A%2F%2Faddons.mozilla.org%2Fzh-CN%2Ffirefox%2Faddon%2Faria2-integration%2F)
            
            ![Snipaste_2018-06-12_23-21-11.png](https://user-gold-cdn.xitu.io/2018/6/13/163f501841afc27a?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
            
            ![Snipaste_2018-06-12_23-21-52.png](dhttps://user-gold-cdn.xitu.io/2018/6/13/163f50186e4bd7bb?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
            
            ![Snipaste_2018-06-12_23-22-53.png](https://user-gold-cdn.xitu.io/2018/6/13/163f5018c16d8c79?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
            
    *   [Safari](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fminiers%2Fsafari2aria) 由于本人没有mac电脑，使用请自行google
        
2.  导出插件：[百度网盘](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Facgotaku%2FBaiduExporter)，[115网盘](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Facgotaku%2F115)，[迅雷离线](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fbinux%2FThunderLixianExporter)
    
3.  Tampermonkey 不得不说下油猴脚本了，使用它可以满足我们在网页中很多需求,如获取百度下载地址。
    
    *   安装 打开[Violentmonkey](https://link.juejin.im?target=https%3A%2F%2Faddons.mozilla.org%2Fzh-CN%2Ffirefox%2Faddon%2Fviolentmonkey%2F) 安装，还有其他两种[Greasemonkey](https://link.juejin.im?target=https%3A%2F%2Faddons.mozilla.org%2Fzh-CN%2Ffirefox%2Faddon%2Fgreasemonkey%2F)、[Tampermonkey](https://link.juejin.im?target=https%3A%2F%2Faddons.mozilla.org%2Fzh-CN%2Ffirefox%2Faddon%2Ftampermonkey%2F) ，根据自己的喜好安装。
    *   下载百度云脚本 到脚本[greasyfork](https://link.juejin.im?target=https%3A%2F%2Fgreasyfork.org%2Fzh-CN%2Fscripts)、[openuserjs](https://link.juejin.im?target=https%3A%2F%2Fopenuserjs.org%2F)市场下载脚本。
    *   下载百度云资源
        
        ![68747470733a2f2f63646e2e7261776769742e636f6d2f6a61652d6a61652f5f7265736f75726365732f6d61737465722f70616e2e676966.gif](https://user-gold-cdn.xitu.io/2018/6/13/163f50192a0a662a?imageslim)
        
4.  下载替换`Proxyee-down` 本地http代理服务器方式嗅探下载请求，支持所有操作系统和大部分主流浏览器,支持分段下载和断点下载。
    
    *   **[Windows安装教程](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2FmonkeyWie%2Fproxyee-down%2Fblob%2Fmaster%2F.guide%2Fwindows%2Fread.md)**
    *   **[MAC安装教程](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2FmonkeyWie%2Fproxyee-down%2Fblob%2Fmaster%2F.guide%2Fmac%2Fread.md)**
    *   **[Linux安装教程](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2FmonkeyWie%2Fproxyee-down%2Fblob%2Fmaster%2F.guide%2Flinux%2Fread.md)**
    
    在安装成功之后，进入浏览器下载资源时会跳转到创建任务页面，然后选择保存的路径和分段数进行创建下载任务。
    
    **[详细教程](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fproxyee-down-org%2Fproxyee-down)**
    
    ![new-task.png](https://user-gold-cdn.xitu.io/2018/6/13/163f5018e69e8835?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)
    

 Aria2进阶
--------

1.  Aria2下载BT磁力的时候，速度慢或者没速度的解决方法使用`Aria2`下载`BT`的时候，都会遇到某些种子没有速度，或者速度很慢的问题。其实对于这个问题，之前在博客就已经提到过了，可以添加`BT Tracker`服务器就可以解决了 `BT Tracker`服务器地址获取方法参考：[分享一些BT Tracker服务器地址](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Fngosang%2Ftrackerslist)。
    
        # bt-tracker=BT服务器（多个服务器之间用,分开）
        # 例如
        bt-tracker=udp://tracker.leechers.paradise.org:6969/announce,udp://:...
        复制代码
    
2.  [aria2-trackers-update.exe](https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2Foloeye%2Fsharingplus%2Fraw%2Fmaster%2FAria2-Android-and-Windows-and-liunx%2Faria2%2Faria2-trackers-update%25201.0.2%2Faria2-trackers-update.exe) 进行自动化更新，将所有文件放入Aria2配置文件（aria2.conf）所在文件夹下,运行aria2-trackers-update.exe即可。默认任务计划从 0点开始 每隔8小时运行一次。程序运行没有任何提示，可以打开aria2.conf查看“bt-trasker”字段是否更新成功。
    
3.  如果下载慢，可以使用代理。连接国外一些节点。有些被墙资源，需要使用代理下载。
    
        --all-proxy=代理 为所有协议的传输使用代理服务器。
        用 ""（空字串）来覆盖之前定义的代理。
        您可以使用 --http-proxy，--https-proxy 和 --ftp-proxy 选项
        为某个协议指定代理服务器。
        复制代码
    
4.  找个热门种子(千万建议是种子，而不是磁力链接)，然后下一波，挂着做种，过几个小时后退出Aria2，或者等Aria2会话自动保存，你会发现dht.dat从空文件变成有数据了
