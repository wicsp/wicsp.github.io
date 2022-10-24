---
title: "V2ray Simple Configuration"
date: "2019-02-20T21:46:25+08:00"
tags: ["科学上网","v2ray","Tools"]
categories: ["Tools"]
---

# 服务器端

### 1. 执行代码安装脚本
`$ wget https://install.direct/go.sh`
### 2. 执行脚本
`$ sudo bash go.sh`
### 3. 更新配置文件
 - 配置文件为 /etc/v2ray 目录下的 config.json
 
`$ vim config.json`

- 添加以下内容：

```json
{
  "inbounds": [
    {
      "port": 23333,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "72245f06-c81c-4175-a88a-9a96d150ca15",
            "alterId": 64
          }
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
```
> `port` 为服务器监听端口，你可以改成自己喜欢的端口
>
>`id` 可以通过[Online UUID Generator](https://www.uuidgenerator.net/version4 "Online UUID Generator")生成

- 保存退出

### 4. 运行v2ray服务
- 执行代码

`$ sudo systemctl start v2ray`
- 停止服务

`$ sudo systemctl stop v2ray`
- 重启服务

`$ sudo systemctl restart v2ray`

### 5. 更新v2ray
- 再次执行脚本（步骤二）

# 客户端
### 1. 下载 v2ray
- 访问 [v2ray/v2ray-core](https://github.com/v2ray/v2ray-core/releases) 下载适合自己的版本并解压到本地

### 2. 配置客户端文件
- 在文件夹中打开 `config.json` 文件并放入以下内容，其中 `server_ip` 为服务器的ip地址，注意 `port`、`id`、`alterId` 要与服务器端配置文件一致
```json
{
  "inbounds": [
    {
      "port": 1080,
      "protocol": "socks",
      "domainOverride": ["tls","http"],
      "settings": {
        "auth": "noauth"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "server_ip",
            "port": 23333,
            "users": [
              {
                "id": "72245f06-c81c-4175-a88a-9a96d150ca15",
                "alterId": 64
              }
            ]
          }
        ]
      }
    }
  ]
}
```

### 3. 运行 v2ray.exe
- 双击运行 v2ray.exe 后，会弹出命令行窗口，并显示状态

- linux 下配置好 config.json 后执行 systemctl start v2ray, 可以通过 systemctl status v2ray 查看运行状态

### 4.chrome 插件配置
- 下载插件 `SwitchyOmega` 并加入 chrome 拓展中，代理服务器设为 `127.0.0.1:1080`，就可以访问 google 了

# 优化
各平台上有很多 v2ray 客户端， 可以带来更好的使用体验， switchy 也可以通过 auto_proxy 进行不同网站的代理控制，网上有许多教程，这里就不细说了
