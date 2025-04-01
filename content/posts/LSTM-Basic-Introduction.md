---
title: "LSTM: A Basic Introduction"
date: 2019-12-25T21:28:47+08:00
tags:
  - ML
  - LSTM
  - RNN
categories:
  - Machine Learning
---

由于梯度消失/梯度爆炸的问题传统 rnn 在实际中很难处理长期依赖，而 LSTM（long short term memory）则绕开了这些问题依然可以从语料中学习到长期依赖关系。

<!-- more -->

传统 rnn 每一步的隐藏单元只是执行一个简单的 tanh 或 relu 操作,如图：

![](https://pic4.zhimg.com/80/v2-99a70ce82af523ed29a9a6f2122b59b7_hd.jpg)

lstm 每个循环的模块内又有 4 层结构:3 个 sigmoid 层，1 个 tanh 层，如图：

![](https://pic1.zhimg.com/80/v2-29954c2e7292846ff142bd4be607fcb0_hd.jpg)

## lstm 内部结构详解

lstm 的关键是细胞状态 c，一条水平线贯穿于图形的上方，这条线上只有些少量的线性操作，信息在上面流传很容易保持。

![](https://pic4.zhimg.com/80/v2-2b06468e314ff1cd64815fef103ca343_hd.jpg)

第一层是个忘记层，决定细胞状态中丢弃什么信息。把 ht−1 和 xt 拼接起来，传给一个 sigmoid 函数，该函数输出 0 到 1 之间的值，这个值乘到细胞状态 ct−1 上去。sigmoid 函数的输出值直接决定了状态信息保留多少。比如当我们要预测下一个词是什么时，细胞状态可能包含当前主语的性别，因此正确的代词可以被选择出来。当我们看到新的主语，我们希望忘记旧的主语。

![](https://pic2.zhimg.com/80/v2-84c1933458ea8e746afe4b6c9487f701_hd.jpg)

上一步的细胞状态 ct−1 已经被忘记了一部分，接下来本步应该把哪些信息新加到细胞状态中呢？这里又包含 2 层：一个 tanh 层用来产生更新值的候选项 c~t，tanh 的输出在[-1,1]上，说明细胞状态在某些维度上需要加强，在某些维度上需要减弱；还有一个 sigmoid 层（输入门层），它的输出值要乘到 tanh 层的输出上，起到一个缩放的作用，极端情况下 sigmoid 输出 0 说明相应维度上的细胞状态不需要更新。在那个预测下一个词的例子中，我们希望增加新的主语的性别到细胞状态中，来替代旧的需要忘记的主语。

![](https://pic3.zhimg.com/80/v2-fc16c93b5ad7631a32694e5221514e5e_hd.jpg)

现在可以让旧的细胞状态 ct−1 与 ft（f 是 forget 忘记门的意思）相乘来丢弃一部分信息，然后再加个需要更新的部分 it∗c~t（i 是 input 输入门的意思），这就生成了新的细胞状态 ctct。

![](https://pic3.zhimg.com/80/v2-6f41fdfa1f3b3dc4e59190c2d356d01a_hd.jpg)

最后该决定输出什么了。输出值跟细胞状态有关，把 ct 输给一个 tanh 函数得到输出值的候选项。候选项中的哪些部分最终会被输出由一个 sigmoid 层来决定。在那个预测下一个词的例子中，如果细胞状态告诉我们当前代词是第三人称，那我们就可以预测下一词可能是一个第三人称的动词。

![](https://pic4.zhimg.com/80/v2-235e1ceaf244329cbfc45878acec9d6b_hd.jpg)

## lstm 详解

单层ｌｓｔｍ结构如下

```python
cell = tf.contrib.rnn.lstmblockcell(hidden_size, forget_bias=0.0)
outputs = []
state = self._initial_state # state
with tf.variable_scope("rnn"):
    for time_step in range(num_steps):
        if time_step > 0: tf.get_variable_scope().reuse_variables()
            # cell_output: [batch_size,hidden_size]
            (cell_output, state) = cell(inputs[:,time_step,:], state)
            # outputs: a list: num_steps elements of shape [batch_size,hidden_size]
            outputs.append(cell_output)

# output: first to shape:[batch_size,num_steps*hidden_size] and the first row is the data of the first sentense
# and then reshpae to shape: [batch_size*num_steps,hidden_size], first num_steps rows is a sentense
output = tf.reshape(tf.concat(outputs,1), [-1, hidden_size])

# 7.softmax: convert wordvec to probability for each word in vocab and calculate cross_entropy loss
# used to find which word in vocab the wordvec is like
softmax_w = tf.get_variable("softmax_w", [hidden_size, vocab_size], dtype=data_type())
softmax_b = tf.get_variable("softmax_b", [vocab_size], dtype=data_type())
```

用 lstmblockcell 构造了一个 lstm 单元，单元里的隐藏单元个数是 hidden_size，有四个神经网络，每个神经网络的输入是$h_t−1$和$x_t$，将它们 concat 到一起，维度为(hidden_size+wordvec_size)，所以 lstm 里的每个黄框的参数矩阵的维度为
[hidden_size+wordvec_size,hidden_size]

需要注意的是，num_steps 个时刻的 lstm 都是共享一套参数的，说是有 num_steps 个 lstm 单元，其实只有一个，只不过是对这个单元执行 num_steps 次。

上面的代码中有个 for 循环，是以时间进行展开，在循环里执行当前时刻下的单词。

举个例子，比如一批训练 64 句话，每句话 20 个单词，每个词向量长度为 200，隐藏层单元个数为 128

那么训练一批句子，输入的张量维度是[64,20,200]，$h_t$,$c_t$ 的维度是[128]，那么 lstm 单元参数矩阵的维度是[128+200,4*128]，

在时刻 1，把 64 句话的第一个单词作为输入，即输入一个[64,200]的矩阵，由于会和$h_t$进行 concat，输入矩阵变成了[64,200+128]，输入矩阵会和参数矩阵[200+128,4*128]相乘，输出为[64,4*128]，也就是每个黄框的输出为[64,128]，黄框之间会进行一些操作，但不改变维度，输出依旧是[64,128]，即每个句子经过 lstm 单元后，输出的维度是 128，所以上一章节的每个 lstm 输出的都是向量，包括$c_t$,$h_t$，它们的长度都是当前 lstm 单元的 hidden_size 得到了解释。那么我们就知道 cell_output 的维度为[64,128]

之后的时刻重复刚才同样的操作，那么 outputs 的维度是[20,64,128].

softmax 相当于全连接层，将 outputs 映射到 vocab_size 个单词上，进行交叉熵误差计算。

然后根据误差更新 lstm 参数矩阵和全连接层的参数。
