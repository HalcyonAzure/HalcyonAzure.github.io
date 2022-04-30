---
layout: post
title: WSL配置Proxy代理引导
categories: 小技巧
tags:
  - WSL
  - zsh
  - Clash
abbrlink: 6088c65c
date: 2022-05-01 02:34:20
---

## 前言

在三番五次被`wsl`的`proxy`问题折腾的心态爆炸，并重装了好几次系统以后，总算理清楚了`WSL`如果想要搭配`windowns`上的`clash for windows`的正确使用方法。把之前无论是需要脚本还是各种复杂操作的博客都删了，在这里记录一个完全不需要任何脚本，也不需要额外配置防火墙的合理方案。

## 工具环境

* `WSL 2 ArchLinux`（理论上来说其他发行版应该相同)
* `Windows 11`（win10应该同理）
* `Clash For Windows`

## Clash的配置

> 改方案为`WSL`继承`System Proxy`来达到代理上网的目的，使用`TUN Mode`直接用就行，不需要额外设置

1. 正常配置好`Clash For Windows`，并且启用`Allow LAN`的设置

2. 在`允许应用或功能通过 Windows Defender防火墙`中寻找是否有`clash-win64.exe`的规则配置，注意不是 **Clash For Windows** ，`CFW`本身只是`clash`的一个前端，在启动`CFW`的时候有概率防火墙只添加`CFW`本身，而不添加作为核心的`clash`的防火墙规则，这个时候则需要我们手动修改

3. 如果已经有了`clash-win64.exe`的规则，则只需要配置**专有和公共网络同时允许**即可。如果没有`clash-win64.exe`的规则，可以通过下方的`允许其他应用`手动添加规则，具体`clash`核心文件的路径可以通过任务管理器后台或`Clash for Windows\resources\static\files\win\x64\clash-win64.exe`类似的路径查询到。添加规则的时候同时允许**专用和公共**即可

> 之前经常折腾好了防火墙但过了三四个月或者一段时间后`wsl`和`windows`之间就因为防火墙断开，但总找不到原因，现在想想很有可能是当时`clash for windows`升级安装的时候规则被覆盖或路径变化导致的。WSL2的网络对Windows来说也是一个Public的公开网络，在设置了单独程序允许通信之后，虽然`wsl`有可能无法`ping`通`windows`的主机，但正常访问`clash`的代理端口是没有问题的

## WSL的配置

到这里为止防火墙的问题就解决了，只需要通过合理的方法配置好`WSL`下的代理变量就可以正常使用。其中`主机名.local`这个域名是会直接在`wsl`内映射到作为`dns`服务器的宿主机上，因此并不需要写额外的脚本来添加映射

较为简单的方法即通过`zsh`终端下`oh my zsh`+ [zsh-proxy](https://github.com/SukkaW/zsh-proxy) 插件，通过设置`proxy`来实现全局基本功能的代理配置，而在`config_proxy`步骤中的代理IP填入类似`Zephyrus.local:7890`格式的地址即可。
> Zephyrus为我Windows的设备名，可在Windows设置中重命名，一般来说默认设置应该为类似`DESKTOP-XXXX.local:7890`，修改和查看的方法可通过搜索引擎自己解决

通过以上方式配置后的`WSL`就可以正常通过`Windows`上的`Clash`代理了。每次`WSL`出网络问题总是感觉莫名其妙没头绪，之前也试过通过`New-NetFireWallRule`一类的方法放行防火墙，但都不是很好用或者后面偶尔突然就出问题，现在总算弄清楚了原因而且能很舒服的使用`win`里面的代理了。
