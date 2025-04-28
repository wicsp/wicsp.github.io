---
tags:
  - blog
title: Use $ as the inline delimiters in hugo&katex
date: 2025-04-28
categories: 
zkcode: "202504281955"
---
When using KaTeX, the default delimiters for inline math are `\(` and `\)`. And due to the markdown rendering engine, you need to use `\\(` and `\\)` actually when writing blog posts, which can be cumbersome. For example, to write `\(\alpha\)`, you need to write `\\(\alpha\\)` in your markdown file. 

To make it more convenient, some additional adjustments can provide a more complete support for LaTeX features we need.

First, find the `renderMathInElement` function in your blog theme files, it's usually in the `layouts/partials/vendor.html`, You can find it by searching for `renderMathInElement`. 

Then, replace the original `renderMathInElement(document.body);` with the following code:

```javascript
renderMathInElement(document.body, 
	{delimiters:[{left: "$$", right: "$$", display: true}, 
	{left: "$", right: "$", display: false}, 
	{left: "\\(", right: "\\)", display: false}, 
	{left: "\\[", right: "\\]", display: true}  ]}
);
```

If you use the theme as a git submodule, it is recommended to copy the `vendor.html` file to your `layouts/partials` folder, and then modify it. This way, you can avoid losing your changes when updating the theme.

This code will add support for `$` and `$$` as the inline delimiters, and you can use them directly in your markdown files.


In additon to that, when you write some multi-line math, you need to use `\\\\` to start a new line. You can add the following code to your `config/_default/hugo.toml` or `config/_default/config.toml` file to support this:

```toml
[markup]

[markup.goldmark]

[markup.goldmark.renderer]

unsafe = true

[markup.goldmark.extensions.passthrough]

enable = true

[markup.goldmark.extensions.passthrough.delimiters]

block = [["\\[", "\\]"], ["$$", "$$"]]

# using $ as the inline-delimiter (optional, maybe)

inline = [["\\(", "\\)"], ["$", "$"]]
```




---
## References
https://github.com/adityatelange/hugo-PaperMod/discussions/131
https://misha.brukman.net/blog/2022/04/writing-math-with-hugo/
