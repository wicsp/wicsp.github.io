---
title: 手算 RSA
date: 2020-07-26
tags:
  - Math
categories:
  - Programming
---

{{< katex >}}

按 RSA 算法规定有如下

$$p \times q =n$$

$$(p-1) \times (q-1) = \varphi(n)$$

任选整数 $e$ 使得 $\gcd(e,\varphi(n))=1$ ,整数 $e$ 用做加密钥（注意：$e$ 的选取是很容易的，例如，所有大于 $p$ 和 $q$ 的素数都可用）。

确定的解密钥 $d$，满足
$$e \times d == 1(\mod n)$$

等价如下
$$e \times d - n \times k =1$$


## 使用辗转相除法计算，分两种情况

### 1. 最后的 k 系数不为 1

例：令 $p=47$，$q=71$，求用 RSA 算法加密的公钥和私钥。

计算如下：

1. $n=pq=47\times 71=3337$

2. $φ(n)=(p-1) \times (q-1)=46\times 70=3220$

3. 随机选取$e=79$(满足与 3220 互质的条件)；

4. 则私钥 d 应该满足：$79\times d \mod 3220 = 1$

那么这个式子 4 如何解呢？这里就要用到欧几里得算法(又称辗转相除法)，解法如下：

(1)式子 4 可以表示成 $79\times d-3220\times k=1$(其中 k 为正整数)；

(2)将 3220 对 79 取模得到的余数 60 代替 3220，则变为 $79\times d-60\times k=1$

(3)同理，将 79 对 60 取模得到的余数 19 代替 79，则变为 $19\times d-60\times k=1$

(4)同理，将 60 对 19 取模得到的余数 3 代替 60，则变为 $19\times d-3\times k=1$

(5)同理，将 19 对 3 取模得到的余数 1 代替 19，则变为 $d-3\times k=1$

当 d 的系数最后化为 1 时，(注：当 k 的系数先化为 1 时，令 d=1，再带入)

令 k=0，代入(5)式中，得 d=1； (注 d 系数先为 1 时， 此处第 1 个式子代入 k=0)

将 d=1 代入(4)式，得 k=6；

将 k=6 代入(3)式，得 d=19；

将 d=19 代入(2)式，得 k=25；

将 k=25 代入(1)式，得 d=1019，这个值即我们要求的私钥 d 的最终值。

### 2. k 系数为 1 的情况

原式: $20\times d \mod 2000001 = 1$,求 d;

用辗转相除法可转换为下列式子：

(1) $20\times d – 2000001 \times k = 1$

(2) $20\times d – 1\times k = 1$

此时 k 的系数已经化为 1;

令 d=1,带入(2)式中，得 k=19; (注：若 k 的系数为 1，则把 d=1 供入原式，求出 k)

令 k=19,带入(1)式中，得 d=1900001

解得：d=1900001

## RSA 中 MOD 快速指数 运算方法

快速指数法是运用公式：$(a \times b)\mod n = [(a \mod n) \times (b \mod n)] \mod n$

例子：$15^{27}\mod 33$

$$
\begin{equation}\begin{split}
        15^{27}\mod 33 & = (15 \times 15^{26})\mod 33 \newline
        & = (15 \times (15^2)^{13}) \mod 33 \newline
        & = (15 \times 27 ^{13} )\mod 33 \newline
        & = (15 \times 27 \times 27 ^{12}) \mod 33 \newline
        & = (9 \times 27^{12}) \mod 33 \newline
        & = (9 \times (27^2)^6) \mod 33 \newline
        & = (9 \times 3 ^6  )\mod 33 \newline
        & = (9\times (3^2)^3 )\mod 33 \newline
        & = (9 \times 9^3 )\mod 33 \newline
        & = (9\times 9\times 9^2)\mod 33 \newline
        & =(15 \times 15 )\mod 33 \newline
        & = 27 \mod 33 \newline
        & = 27
\end{split}\end{equation}
$$
