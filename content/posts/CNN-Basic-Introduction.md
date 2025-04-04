---
title: CNN Basic Introduction
date: 2019-12-25T21:20:35+08:00
tags:
  - ML
  - CNN
categories:
  - Machine Learning
---

对于图像应用，我们经常在神经网络上使用卷积（Convolutional Neural Network），通常缩写为 CNN。

<!-- more -->

下图为 CNN 的基本模型:
![](https://pic3.zhimg.com/v2-7a147703c5181ff9737b41afa6ea6bce_1200x500.jpg)
![](https://images2015.cnblogs.com/blog/1093303/201704/1093303-20170430194254881-664443051.jpg)

卷积神经网络的层级结构

- 数据输入层/ Input layer
- 卷积计算层/ CONV layer
- ReLU 激励层 / ReLU layer
- 池化层 / Pooling layer
- 全连接层 / FC layer

一般为一般 CNN 结构依次为

1. INPUT
2. [[CONV -> RELU]*N -> POOL?]*M
3. [FC -> RELU]\*K
4. FC

## 基础原理

一般的，CNN 的基本结构包括两层，其一为特征提取层，每个神经元的输入与前一层的局部接受域相连，并提取该局部的特征。一旦该局部特征被提取后，它与其它特征间的位置关系也随之确定下来；其二是特征映射层，网络的每个计算层由多个特征映射组成，每个特征映射是一个平面，平面上所有神经元的权值相等。特征映射结构采用影响函数核小的 sigmoid 函数作为卷积网络的激活函数，使得特征映射具有位移不变性。此外，由于一个映射面上的神经元共享权值，因而减少了网络自由参数的个数。卷积神经网络中的每一个卷积层都紧跟着一个用来求局部平均与二次提取的计算层，这种特有的两次特征提取结构减小了特征分辨率。

CNN 主要用来识别位移、缩放及其他形式扭曲不变性的二维图形，该部分功能主要由池化层实现。由于 CNN 的特征检测层通过训练数据进行学习，所以在使用 CNN 时，避免了显式的特征抽取，而隐式地从训练数据中进行学习；再者由于同一特征映射面上的神经元权值相同，所以网络可以并行学习，这也是卷积网络相对于神经元彼此相连网络的一大优势。卷积神经网络以其局部权值共享的特殊结构在语音识别和图像处理方面有着独特的优越性，其布局更接近于实际的生物神经网络，权值共享降低了网络的复杂性，特别是多维输入向量的图像可以直接输入网络这一特点避免了特征提取和分类过程中数据重建的复杂度。

### 简单示例

假设给定一张图（可能是字母 X 或者字母 O），通过 CNN 即可识别出是 X 还是 O，如下图所示，那怎么做到的呢

![](https://img2018.cnblogs.com/blog/1226410/201810/1226410-20181009202515631-1056461501.png)

如果采用经典的神经网络模型，则需要读取整幅图像作为神经网络模型的输入（即全连接的方式），当图像的尺寸越大时，其连接的参数将变得很多，从而导致计算量非常大。
　　而我们人类对外界的认知一般是从局部到全局，先对局部有感知的认识，再逐步对全体有认知，这是人类的认识模式。在图像中的空间联系也是类似，局部范围内的像素之间联系较为紧密，而距离较远的像素则相关性较弱。因而，每个神经元其实没有必要对全局图像进行感知，只需要对局部进行感知，然后在更高层将局部的信息综合起来就得到了全局的信息。这种模式就是卷积神经网络中降低参数数目的重要神器：局部感受野。

![](https://img2018.cnblogs.com/blog/1226410/201810/1226410-20181009202559906-1527391226.png)

如果字母 X、字母 O 是固定不变的，那么最简单的方式就是图像之间的像素一一比对就行，但在现实生活中，字体都有着各个形态上的变化（例如手写文字识别），例如平移、缩放、旋转、微变形等等，如下图所示：

![](https://img2018.cnblogs.com/blog/1226410/201810/1226410-20181009202627271-1361985686.png)

我们的目标是对于各种形态变化的 X 和 O，都能通过 CNN 准确地识别出来，这就涉及到应该如何有效地提取特征，作为识别的关键因子。回想前面讲到的“局部感受野”模式，对于 CNN 来说，它是一小块一小块地来进行比对，在两幅图像中大致相同的位置找到一些粗糙的特征（小块图像）进行匹配，相比起传统的整幅图逐一比对的方式，CNN 的这种小块匹配方式能够更好的比较两幅图像之间的相似性。如下图：

![](https://img2018.cnblogs.com/blog/1226410/201810/1226410-20181009202646989-200335159.png)

以字母 X 为例，可以提取出三个重要特征（两个交叉线、一个对角线），如下图所示

![](https://img2018.cnblogs.com/blog/1226410/201810/1226410-20181009202702561-93616180.png)

假如以像素值"1"代表白色，像素值"-1"代表黑色，则字母 X 的三个重要特征如下：

![](https://img2018.cnblogs.com/blog/1226410/201810/1226410-20181009202719374-1192154873.png)

那么我们通过匹配图片的特征就可以识别出图片

### 卷积层介绍

这一层就是卷积神经网络最重要的一个层次，也是“卷积神经网络”的名字来源。
在这个卷积层，有两个关键操作：

- 局部关联。每个神经元看做一个滤波器(filter)
- 窗口(receptive field)滑动， filter 对局部数据计算

卷积层重要名词：

- 深度/depth（解释见下图）
- 步长/stride （窗口一次滑动的长度）
- 填充值/zero-padding

![](https://images2015.cnblogs.com/blog/1093303/201704/1093303-20170430194425147-845167791.png)

填充值是什么呢？以下图为例子，比如有这么一个 5*5 的图片（一个格子一个像素），我们滑动窗口取 2*2，步长取 2，那么我们发现还剩下 1 个像素没法滑完，那怎么办呢？

![](https://images2015.cnblogs.com/blog/1093303/201704/1093303-20170430194452615-1175169258.png)

那我们在原先的矩阵加了一层填充值，使得变成 6\*6 的矩阵，那么窗口就可以刚好把所有像素遍历完。这就是填充值的作用。
![](https://images2015.cnblogs.com/blog/1093303/201704/1093303-20170430194526537-1629104898.png)

卷积的计算（注意，下面蓝色矩阵周围有一圈灰色的框，那些就是上面所说到的填充值）
![](https://images2015.cnblogs.com/blog/1093303/201704/1093303-20170430194547100-2091436500.jpg)

蓝色的矩阵(输入图像)对粉色的矩阵（filter）进行矩阵内积计算并将三个内积运算的结果与偏置值 b 相加,如图：
![](https://images2015.cnblogs.com/blog/1093303/201704/1093303-20170430194806256-1671846037.png)

### 应用

卷积神经网络之典型 CNN

- LeNet，这是最早用于数字识别的 CNN
- AlexNet， 2012 ILSVRC 比赛远超第 2 名的 CNN，比
- LeNet 更深，用多层小卷积层叠加替换单大卷积层。
- ZF Net， 2013 ILSVRC 比赛冠军
- GoogLeNet， 2014 ILSVRC 比赛冠军
- VGGNet， 2014 ILSVRC 比赛中的模型，图像识别略差于 GoogLeNet，但是在很多图像转化学习问题(比如 object detection)上效果奇好

## 总结

卷积网络在本质上是一种输入到输出的映射，它能够学习大量的输入与输出之间的映射关系，而不需要任何输入和输出之间的精确的数学表达式，只要用已知的模式对卷积网络加以训练，网络就具有输入输出对之间的映射能力。

CNN 一个非常重要的特点就是头重脚轻（越往输入权值越小，越往输出权值越多），呈现出一个倒三角的形态，这就很好地避免了 BP 神经网络中反向传播的时候梯度损失得太快。

卷积神经网络 CNN 主要用来识别位移、缩放及其他形式扭曲不变性的二维图形。由于 CNN 的特征检测层通过训练数据进行学习，所以在使用 CNN 时，避免了显式的特征抽取，而隐式地从训练数据中进行学习；再者由于同一特征映射面上的神经元权值相同，所以网络可以并行学习，这也是卷积网络相对于神经元彼此相连网络的一大优势。卷积神经网络以其局部权值共享的特殊结构在语音识别和图像处理方面有着独特的优越性，其布局更接近于实际的生物神经网络，权值共享降低了网络的复杂性，特别是多维输入向量的图像可以直接输入网络这一特点避免了特征提取和分类过程中数据重建的复杂度。
