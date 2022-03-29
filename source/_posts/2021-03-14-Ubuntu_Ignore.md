---
layout: article
title: "Ubuntu禁用Suspend"
tag: Linux
---

> 前段时间一直希望能有一个自己方便的，不限速的网络存储工具，可以及时存入自己的工具的同时运行一些自己需要的工具，并且为日后Minecraft服务器的搭建做一定准备，先把可能遇到的问题排除

## 前言

由于用笔记本做服务器的时候并不需要屏幕显示，并且屏幕显示会带来多余的耗电，于是就想试着把笔记本屏幕关上的同时能让Ubuntu Server正常运行，而不是进入休眠模式，索性在网上查阅资料以后发现并不是很困难，以此在这里记录需要修改的操作以便以后查阅

1. 修改logind.conf文件

   `sudo vim /etc/systemd/logind.conf`

2. 修改logind.conf中的选项，使得笔记本忽略关闭屏幕对系统的影响

   将原本的

   ```yaml
   #HandleLidSwitch=suspend
   #HandleLidSwitchExternalPower=suspend
   ```

   改为

   ```yaml
   HandleLidSwitch=ignore
   HandleLidSwitchExternalPower=ignore
   ```

3. 使用`reboot`指令来重启电脑即可。
