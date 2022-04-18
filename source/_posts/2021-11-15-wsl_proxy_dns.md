---
layout: post
title: "WSL通过zsh设置代理，并设置开机自启动"
date: 2021-11-15 10:00:00
categories: 小技巧
tags: [WSL, zsh]
---

## 前言

这算是被WSL折腾代理的第三次了。前两次解决代理的方案分别是通过脚本获取到Windows的IP之后再设置proxy，当时因为防火墙的问题不知道为什么总是不能生效。之后采取的是通过Clash开启网卡代理，让所有流量都能经过Clash处理，自然也就能处理WSL2中的流量了。但这样处理的致命缺点就是所有的流量都由Clash代理，其中的性能使用不可小觑，所以最后还是采取了WSL+Zsh的Proxy插件的方式来实现常见需求的代理。

在进行操作之前首先要有的操作：

* 安装好`zsh`，并安装`zsh-proxy`

## 操作流程

* 在Windows开机的时候自动启动WSL内的脚本，同时修改该进程下的WSL的Host
* 添加一个脚本，在每次WSL开机的时候自动将宿主机的IP映射到`win.lan`这个DNS上
* 设置Zsh的Proxy为宿主机的Clash代理地址
* Clash设置并开启了代理服务

## 在Windows内开机自启动WSL

由于Host文件在每次WSL重新启动的时候都会自动刷新（手动禁止Host的更新感觉不太优雅），加上WSL本身也比较轻量化，所以最后方案考虑为开机自启动WSL，同时更新WSL的Host文件。以下为创建WSL开机自启动的教程：

1. 在Windows下按`win+R`，输入`shell:startup`回车打开开机启动目录

2. 创建脚本文件`wsl.vbs`，并写入以下内容来让WSL持续运行：

   ```vbscript
   Set ws = WScript.CreateObject("WScript.Shell")        
   ws.run "wsl -d Ubuntu-20.04 -u root /etc/init.wsl",0
   ```

3. 同时在WSL中创建/etc/init.wsl文件，写入以下内容：

   ```shell
   #! /bin/sh
   /etc/init.d/ssh start
   /etc/init.d/cron start
   /etc/init.d/windns.sh  ## 用于更改windows的DNS的脚本
   ```

   以上在Windows的操作结束，下面的内容都在WSL中进行：

## 脚本添加

1. 创建一个脚本文件，写入以下内容：

   ```shell
   #!/bin/sh
   winip=$(< /etc/resolv.conf  grep nameserver | awk '{ print $2 }')
   echo "Windows Current IP:""${winip}"
   currentIP=$(< /etc/hosts  grep "win.lan" | awk '{ print $1 }')
   echo "Current Host IP:""${currentIP}"
   
   if [ "${currentIP}" = "" ]; then
       echo "${winip} win.lan" >> /etc/hosts
       echo "添加host完成"
       exit 0
   fi
   
   if [ "${winip}" = "${currentIP}" ]; then
       echo "No need to change host"
       exit 0;
   else
       echo "Start to change host"
   
       old=$(< /etc/hosts grep "win.lan")
       new=${winip}" win.lan"
       sudo sed -i "s/${old}/${new}/g" /etc/hosts
       echo "修改host完成"
       check=$(< /etc/hosts grep "win.lan")
       echo "${check}"
       exit 0
   fi
   ```

2. 保存后，假设文件名字为`windns.sh`，输入以下指令：

   ```shell
   chmod +x windns.sh
   sudo mv windns.sh /etc/init.d/
   sudo update-rc.d windns.sh defaults 100
   ```

3. 后续如果要删除这个脚本，只需要执行以下指令即可：

   ```shell
   sudo update-rc.d windns.sh remove
   sudo rm /etc/init.d/windns.sh
   ```

## WSL开机自启

## Zsh设置Proxy

首先输入`init_proxy`初始化代理，然后输入`config_proxy`对代理进行配置，在配置完毕最后，输入`proxy`应用代理

> Tips:如果不想继续使用代理了，可以使用`noproxy`来关闭代理，`zsh-proxy`代理了大部分，包括`git`、`npm`和`apt`等常用的工具。
