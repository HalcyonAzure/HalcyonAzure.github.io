---
layout: article
title: "Ubuntu的Vim编辑器中方向键变成ABCD的解决办法"
date: 2021-3-14
description: "在一些Linux发行版中使用Vi/Vim编辑器时，偶尔会遇到在Insert模式下无法使用方向键移动光标的问题，并且还会输入诸如B/D等字符，解决方法如下。"
tag: Ubuntu-小问题
---
----
> 参考:[Ubuntu的Vi/Vim编辑器的方向键变成ABCD问题_colorfulshark-CSDN博客](https://blog.csdn.net/wr132/article/details/53769257)
>

在终端输入如下指令:

```
echo "set nocp" >> ~/.vimrc
source ~/.vimrc
```