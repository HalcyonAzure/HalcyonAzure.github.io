---
layout: article
title: "Windows下修改网络优先级广播ZeroTier进行游戏"
date: 2021-08-30
categories: 小技巧
tags: [Windows, ZeroTier]
---

## 前言

​    经常能遇到需要和朋友联机玩一些P2P的联机游戏，但游戏服务器总是因为各种原因延迟很高或者连不上的情况。在使用诸如`ZeroTier`等一类软件进行组网的时候，在此给出能够让`Windows`提高虚拟网卡的优先级，让游戏能够在一些无法输入IP的游戏中扫描到同一虚拟局域网下用户的方法。

## 步骤

### 创建ZeroTier网络

> 在谷歌搜索“创建`ZeroTier`网络”关键词即可找到许多对应教程，在此不多赘述
>
> 在有条件的情况下，可以自己搭建`Moon中转`节点来加速（非必须），教程：[ZeroTier下Moon服务器的搭建](https://halc.top/2021/03/24/Moon-Server-of-ZeroTier.html)

### 修改Windows设置

>该教程以Windows10为例，其他版本的Windows可参考设置

1. 在电脑右下角打开“**网络和Internet**”选项

   ![网络和Internet](https://lsky.halc.top/NeXLax.png)

2. 打开"**更改适配器选项**"

   ![更改适配器选项](https://lsky.halc.top/pBsuTe.png)

3. 打开对应ZeroTier的ID的网络属性

   ![网络属性](https://lsky.halc.top/oXOE9l.png)

4. 打开"**Internet 协议版本 4**"下的"**属性**"

   ![IPv4的属性](https://lsky.halc.top/dOUiQS.png)

5. 打开属性中的“**高级**”

   ![高级](https://lsky.halc.top/13fbHK.png)

6. 修改自动跃点

      > ​    自动跃点的修改就笔者目前看来对日常使用影响不大，介意的可以在和好友联机结束以后重新勾选即可。并且由测试来看，只要重新连接了网络，Windows都会设置回为“自动跃点”

      ![自动跃点](https://lsky.halc.top/A217p1.png)

      > 将优先级设置为1如果不放心的话可以设置为小一点的数字，不过也许有概率无法自动扫描局域网内其他游戏玩家。

## 游戏内

   ​     在进行了上面的操作，并且两个用户都处于同一ZeroTier的网络下之后，直接打开游戏存档并进入，应该就能在局域网联机中自动扫描到对方。目前已经测试的游戏有：无主之地3、GTFO等，理论上所有可以使用局域网加入的游戏应该都能用相同的方法进行操作。
