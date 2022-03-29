---
layout: article
title: "Vim不兼容模式光标错误"
tag: [Linux, Vim]
---
----
> 参考:
>
>   1. [Ubuntu的Vi/Vim编辑器的方向键变成ABCD问题_colorfulshark-CSDN博客](https://blog.csdn.net/wr132/article/details/53769257)
>   2. [Vim入门基本设置](http://edyfox.codecarver.org/html/_vimrc_for_beginners.html)

在终端输入如下指令:

```bash
echo "set nocp" >> ~/.vimrc
source ~/.vimrc
```

> 出现问题的原因：
>
> set nocp
>
> 该命令指定让 VIM 工作在不兼容模式下。在 VIM 之前，出现过一个非常流行的编辑器叫 vi。VIM 许多操作与 vi 很相似，但也有许多操作与 vi 是不一样的。如果使用“:set cp”命令打开了兼容模式开关的话，VIM 将尽可能地模仿 vi 的操作模式。
>
> 也许有许多人喜欢“最正统的 vi”的操作模式，对于初学者来说，vi 里许多操作是比较不方便的。
>
> 举一个例子，VIM 里允许在 Insert 模式下使用方向键移动光标，而 vi 里在 Insert 模式下是不能移动光标的，必须使用 ESC 退回到 Normal 模式下才行。
