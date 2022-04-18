---
layout: post
title: "WSL关闭防火墙，并通过Clash的TUN模式代理"
date: 2021-09-16 10:00:00
categories: 小技巧
tags: [WSL, Clash]
---

## 摘抄文章

* [WSL2 的一些网络访问问题](https://lengthmin.me/posts/wsl2-network-tricks/)

## 前置知识补充

>1. Windows 和 WSL2 算是在同一个局域网内，这个局域网是由 Hyper-V 创建的。
>2. WSL2 使用的网络适配器是 ‘Default Hyper-V Switch’，这个适配器每次重启都会被删除重建，这就是 WSL2 为什么 IP 不固定的原因。
>3. WSL2 内有些微软特意做的东西：
>
  1. 向 **WSL2 的 IP** 发送的请求都会被转发到 **Windows 的 IP** 上，但是这个时灵时不灵。

## 代理配置

### 方案一

#### 主机设置代理端口，WSL通过端口代理

1. 首先需要获取到主机的IP，用以下指令可以达到获取ip的效果：

   ```shell
   ip route | grep default | awk '{print $3}'
   ## 或者
   cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }'
   ```

2. 通过上面的指令获取到主机的ip后，然后通过`shell`脚本手动设置代理即可。以下为在临时ssh中设置的脚本：

   ```shell
   #!/bin/bash
   host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
   export ALL_PROXY="http://$host_ip:7890"
   echo $ALL_PROXY
   ```

   由于$host_ip是由`Hyper-V`的网卡自动分配的，每次可能会不一样，所以如果需要永久方案可以将以上脚本设置为wsl启时自启。

##### WSL防火墙配置

​    在部分时候可能会出现由于防火墙问题，代理设置无法生效，WSL无法访问主机的问题，这个时候可以通过以下指令来开放`vEthernet(WSL)`网卡的防火墙：

>感谢评论区 [Xing Fang](https://disqus.com/by/xing_fang/) 以及 [twinmegami](https://disqus.com/by/twinmegami/) 给的开放防火墙的命令。
>
>命令来源：<https://github.com/microsoft/WSL/issues/4585>
>
>```powershell
>## 直接放开 `vEthernet (WSL)` 这张网卡的防火墙
>New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL)" -Action Allow
>```

### 方案二

#### 2021.12.6为止，CFW自己的0.19.0版本已经自带TUN的切换(fake-ip模式)

#### 通过Clash的TUN模式接管电脑所有软件的网络(redir-host模式)

> 博客记录的是最新版本的Clash下通过mixin模式开启TUN模式的简单办法，具体操作仅供参考。

1. 进入网站[Wintun](https://www.wintun.net/)，点击界面中`Download Wintun xxx`下载压缩包，根据系统版本将对应目录中`wintun.dll`复制至`Home Directory`目录中。基于`x64`的处理器的`64`位操作系统请使用`amd64`版本，`32`位操作系统请使用`x86`版本

2. 点击`General`中`Service Mode`右边`Manage`，在打开窗口中安装服务模式，安装完成应用会自动重启，Service Mode 右边地球图标变为`绿色`即安装成功

    > 以上两点来自于[TUN 模式 Clash for Windows](https://docs.cfw.lbyczf.com/contents/tun.html#windows)

3. 启用Clash中的`Mixin选项`

4. 在`Settings`中找到`Profile Mixin`，点击`YAML`边上的`Edit`，编辑为以下内容(***注意缩进***)：

   ```shell
   mixin: ## object
     dns:
       enable: true
       enhanced-mode: redir-host
       nameserver:
         - 1.1.1.1 ## 真实请求DNS，可多设置几个
         - 114.114.114.114
         - 8.8.8.8 
     ## interface-name: WLAN ## 出口网卡名称，或者使用下方的自动检测
     tun:
       enable: true
       stack: gvisor ## 使用 system 需要 Clash Premium 2021.05.08 及更高版本
       dns-hijack:
         - 198.18.0.2:53 ## 请勿更改
       auto-route: true
       auto-detect-interface: true ## 自动检测出口网卡
   ```

5. 保存后重启电脑，启动`System Proxy`以后在网络适配器能发现多了一个`Clash Tunnel`的网卡，并且`WSL`也不需要任何配置即可正常学习使用。
