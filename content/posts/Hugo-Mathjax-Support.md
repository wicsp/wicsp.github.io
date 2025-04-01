---
title: 在 Hugo 中使用数学公式
date: 2020-07-26T18:52:55+08:00
tags:
  - Hugo
  - Mathjax
categories:
  - Tools
---

> 来源: [在 Hugo 中使用 MathJax](https://note.qidong.name/2018/03/hugo-mathjax/)

<!-- more -->

## ~~本站方案~~本站已迁移到 Hexo & NexT

本站在添加 MathJax 时，把所有修改写成了一个`layouts/partials/mathjax.html`文件：

```html
<script
  type="text/javascript"
  async
  src="https://cdn.bootcss.com/mathjax/2.7.3/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
>
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [['$','$'], ['\\(','\\)']],
      displayMath: [['$$','$$'], ['\[\[','\]\]']],
      processEscapes: true,
      processEnvironments: true,
      skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
      TeX: { equationNumbers: { autoNumber: "AMS" },
           extensions: ["AMSmath.js", "AMSsymbols.js"] }
    }
  });

  MathJax.Hub.Queue(function() {
      // Fix <code> tags after MathJax finishes running. This is a
      // hack to overcome a shortcoming of Markdown. Discussion at
      // https://github.com/mojombo/jekyll/issues/199
      var all = MathJax.Hub.getAllJax(), i;
      for(i = 0; i < all.length; i += 1) {
          all[i].SourceElement().parentNode.className += ' has-jax';
      }
  });
</script>

<style>
  code.has-jax {
    font: inherit;
    font-size: 100%;
    background: inherit;
    border: inherit;
    color: #515151;
  }
</style>
```

这里，把官网的三处修改合并成一个 partial。 此外，还把 MathJax 的 CDN 从`cdnjs.cloudflare.com`替换成了`cdn.bootcss.com`，更好地支持国内。 因为个人的一些写作习惯，还替换了区块公式的第二标志，从中括号`[]`换成双中括号。

把这个 partial 模板添加到`<head>`中，即可正常工作。

```go
{{ partial "mathjax.html" . }}
```
