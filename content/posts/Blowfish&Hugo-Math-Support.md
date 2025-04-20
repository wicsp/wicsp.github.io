---
title: 在 Blowfish@Hugo 中使用数学表达式
date: 2025-03-31T18:52:55+08:00
tags:
  - Hugo
  - Blowfish
  - Math
categories:
  - Tools
---

> 本文为测试页面，介绍了在 Blowfish@Hugo 中使用数学表达式的方法。
> 
> Ref：[Blowfish 数学表达式](https://blowfish.page/zh-cn/samples/mathematical-notation/)

{{< katex >}}

KaTeX 可用于在文章中呈现数学表达式。

如果您想要使用数学符号，Blowfish 会将 KaTeX 自动加入到您的项目中。只需在文章中包含 katex 短代码 即可。参考下面的例子


```
{{< katex >}}
```


# 内联表示法
可以通过将表达式包装在 `\\(` 和 `\\)` 分隔符中来生成内联表示法。
例如：
```
% KaTeX inline notation
Inline notation: \\(\varphi = \dfrac{1+\sqrt5}{2}= 1.6180339887…\\)
```

Inline notation: \\(\varphi = \dfrac{1+\sqrt5}{2}= 1.6180339887…\\)

# 表达式块
可以使用 `$$` 分隔符生成表达式块。这将在其 HTML 块中输出表达式。

**例如：**

```
% KaTeX block notation
$$
 \varphi = 1+\frac{1} {1+\frac{1} {1+\frac{1} {1+\cdots} } }
$$
```

$$
\varphi = 1+\frac{1} {1+\frac{1} {1+\frac{1} {1+\cdots} } }
$$
