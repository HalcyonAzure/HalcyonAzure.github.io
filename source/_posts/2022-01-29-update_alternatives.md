---
layout: article
title: "Linux通过alternatives切换程序版本环境"
date: 2022-01-29
categories: 小技巧
tags: Linux
---

## 参考帖子

1. [How to install and switch between different python versions in ubuntu 16.04](https://medium.com/analytics-vidhya/how-to-install-and-switch-between-different-python-versions-in-ubuntu-16-04-dc1726796b9b)

## 具体操作

在切换Java版本的时候，通过`update-alternatives`可以很方便的进行版本之间的切换，而在Python里面，如果用`Ubuntu`自己的`apt`包管理器同时下载了多个版本的`Python`的话，则需要自己手动对`Python`的版本进行切换设定（切换版本还有alias等方法，这里不提及）。指令如下：

1. 在安装了多个版本的Python之后（其他语言同理），通过类似以下指令的格式添加对应的程序优先级：

    ```shell
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2
    ```

2. 由上面设置的程序指令为`python`，接下来通过以下指令对`python`的版本进行切换：

    ```shell
    sudo update-alternatives --config python
    ```

    输入之后可以见到类似如下的选择：

    ```shell
    There are 2 choices for the alternative python (providing /usr/bin/python).

    Selection    Path                Priority   Status
    ------------------------------------------------------------
    * 0            /usr/bin/python3.8   2         auto mode
    1            /usr/bin/python2.7   1         manual mode
    2            /usr/bin/python3.8   2         manual mode

    Press <enter> to keep the current choice[*], or type selection number:
    ```

    只需要在number后面输入对应需要的优先级，即可对`python`的版本进行切换。

> 每次都会忘记是`update alternatives`还是`alternatives-update`，所以写一篇博客记录一下...自己还是太Native了。
