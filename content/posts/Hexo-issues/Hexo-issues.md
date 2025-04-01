---
title: Hexo & NexT 部署和使用过程中问题合集/Hexo Issues Set
date: 2024-07-20 01:22:32
tags:
  - Hexo
categories:
  - Tools
---

![](https://static.wicsp.top/vFfG0tb4mX1l.png)
本文介绍了我在部署和使用 Hexo 和NexT的过程中遇到的问题和解决方法，仅供参考

> hexo: 7.3.0
> hexo-cli: 4.3.2
> NexT: 8.20.0

<!-- more -->

## 0x00 部署 Hexo 到 GitHub Page 后，自定义域名 (Custom Domain) 失效

在 `source` 文件夹下新建 `CNAME` 文件，其中写入绑定的域名即可。

## 0x01 部署 Hexo 到 GitHub Page 后, 如何展示自定义的 404 页面

在 `source` 文件夹下新建 `404.md` 文件，示例内容如下

```markdown
---
title: 404
permalink: /404.html
comments: false
---

<center>404 Not Found</center>

---

对不起，您所访问的页面不存在或者已删除
```

> Ref:
> [GitHub Docs](https://docs.github.com/zh/pages/getting-started-with-github-pages/creating-a-custom-404-page-for-your-github-pages-site)
> [Gui Blog](https://guiblogs.com/hexo30-20/)


## 0x02 NexT 主体下 Waline 评论系统调整

{% note warning %}
Waline 已经更新到了 3.0 版本，但是 NexT 主题的 Waline 仍然使用的是 `client@v2`，因此在使用时可能会出现一些问题。
{% endnote %}

> 由于 `Valine` 的 XSS 漏洞，NexT 不再对 `Vline` 提供原生支持。 Waline 解决了安全性问题，虽然 NexT 展示也没有原生支持 `Waline`，但是可以通过配置文件进行修改。
> Waline安装和配置参考[官方文档](https://waline.js.org/guide/get-started/) ；Waline for Hexo NexT 网上教程很多，这里不再赘述。

### 增加自动暗黑模式

在 `waline:` 下增加  `dark: auto`
示例如下：
```yaml
waline:
  enable: true #是否开启
  dark: auto
```

### 自定义用户头像风格

自定义用户的头像可以参考[这里](https://innerso.prvcy.page/posts/configure-waline/)，能把原本很丑的默认头像变好看一点。



## 增加 Search 功能

> Ref: [Hexo-Next Doc](https://hexo-next.readthedocs.io/zh-cn/latest/next/advanced/搜索服务/)

并不知道 `hexo-generator-searchdb` 和 `hexo-generator-search`的区别。。

## 不蒜子本地部署时统计有误

三项统计数据都异常大

{% gp %}
![文章阅读数](https://static.wicsp.top/CUf47NE5ASG9.png)
![博客访问数](https://static.wicsp.top/KL91UUEPKatO.png)

{% endgp %}


网上得到的结果是：正常现象，由于本地部署时大家都使用一样的 IP 地址，所以统计数据会出现问题。线上部署后问题消失。

## 部署时每次都要 Hexo g & Hexo d 太麻烦

博客修改后直接使用 `hexo d -g` 即可。


## VSCode 粘贴图片指定默认路径

使用 VScode 自带的 markdown copy file 功能，允许将图片直接粘贴进 Markdown 文档，并自动将图片保存在指定目录。

使用快捷键 `Command + ,` 打开设置，搜索 `markdown`，找到 `Markdown> Copy Files：Destnation`，添加一项 `key` 为 `*` , ` value` 为 `${documentWorkspaceFolder}/source/uploads/${documentBaseName}/` 。

我这里在 `source` 文件夹下新建了一个 `uploads` 文件夹，用于存放图片，并将图片保存在与 markdown 文件同名的文件夹下。

截图后直接在文档中粘贴，结果如下：

![VSCode 粘贴图片展示](https://static.wicsp.top/Bpls0cVE6Azb.png)

{% note info %}
现在已使用图床，不再使用本地图片
{% endnote %}

## 设置博文在主页展示的长度

在文中合适位置加入 `<!-- more -->` 即可。

## MathJax 优化

使用默认的markdown 渲染器 marked 时公式会出现冲突 ([doc](https://theme-next.js.org/docs/third-party-services/math-equations)), 因此替换渲染器为 pandoc（需要在系统中[下载pandoc](https://github.com/jgm/pandoc)）。若安装后还是报错，重启电脑后即可解决。

执行
```sh
npm un hexo-renderer-marked --save
npm i hexo-renderer-pandoc --save # 需要先在本地安装 pandoc
hexo clean
```

## 使用pangu 优化排版

在配置文件中启用 pangu 即可

```yaml
# _config.yml 

# Pangu Support
# For more information: https://github.com/vinta/pangu.js
# Server-side plugin: https://github.com/next-theme/hexo-pangu
pangu: true
```
## favicon 相关
除了主题config中的设置，还可以自己加入一些其他平台的favicon，这里推荐一个工具[Favicon Checher](https://realfavicongenerator.net/favicon_checker) 检测自己网站的favicon情况，然后使用官方提供的 [Favicon Genarator](https://realfavicongenerator.net) 生成并补全 favicon文件。
