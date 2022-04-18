---
layout: post
title: ZeroTier的私有DNS服务器ZeroNSD搭建引导
categories: 安装引导
tags: ZeroTier
abbrlink: 447b77e9
date: 2021-09-09 10:00:00
---

## 翻译来源

* [zeronsd/quickstart.md](https://github.com/zerotier/zeronsd/blob/main/docs/quickstart.md)

> 翻译的时间为2021-9-9，其中部分内容有删改，只提取了主观认为有用的信息，仅供参考

## 安装步骤

### 注意事项

1. 这个功能目前还在Beta测试当中
2. 这个功能将会内嵌在未来将出现的`ZeroTier 2.0`当中，不过目前它是一个独立的软件
3. 接下来的步骤将会有一定困难

### 概念须知

1. 当`ZeroTier`加入了一个网络后，它将会创建一个虚拟网口
2. 当`ZeroTier`加入了多个网络后，也会有多个虚拟网口
3. 当`ZeroNSD`启动了之后，它将绑定在某一个特定的网口上
4. 如果你需要对多个网络都使用`ZeroNSD`，那你也需要创建多个`ZeroNSD`服务绑定在它对应的网口上

## 安装环境

​    该教程使用了两台不同的机器，一台是在云上的Ubuntu虚拟机，另外一台为Windows笔记本，如果要跟着来完成这个快速上手，最好使用相同的平台，如果使用了不同的平台，你最好要有能力弄清楚自己要做什么。

## 搭建教程

### ZeroTier 网络创建

1. 按正常流程创建、链接并授权一个以在[ZeroTier官网](my.zerotier.com)创建的`network`

2. 在自己的帐号的`Account`页面下创见一个新的`API Token`，`ZeroNSD`将会利用这个`token`来获取对应网络下设备的不同名字，来达到自动分配dns的效果。

3. 创建一个文件来让`ZeroNSD`能够以文件的方式读取`token`，参考指令如下 **需要修改token为自己的token**：

   ```shell
   sudo bash -c "echo ZEROTIER_CENTRAL_TOKEN > /var/lib/zerotier-one/token"
   sudo chown zerotier-one:zerotier-one /var/lib/zerotier-one/token
   sudo chmod 600 /var/lib/zerotier-one/token
   ```

4. 安装`ZeroTier`的进程管理应用

   `zerotier-systemd-manager`的`rpm`和`deb`安装包发布在这个网站：<https://github.com/zerotier/zerotier-systemd-manager/releases>，请自行替换下面指令为最新的安装包。

   ```shell
   wget https://github.com/zerotier/zerotier-systemd-manager/releases/download/v0.2.1/zerotier-systemd-manager_0.2.1_linux_amd64.deb
   sudo dpkg -i zerotier-systemd-manager_0.2.1_linux_amd64.deb
   ```

5. 重启所有的ZeroTier服务

   ```shell
   sudo systemctl daemon-reload
   sudo systemctl restart zerotier-one
   sudo systemctl enable zerotier-systemd-manager.timer
   sudo systemctl start zerotier-systemd-manager.timer
   ```

### 安装ZeroNSD

> ZeroNSD针对每一个网络需要都创建一个独立的服务，对DNS来说延迟是很敏感的，所以最好让客户端和服务端尽可能接近

1. 安装`ZeroNSD`，它的安装包发布在[这里](https://github.com/zerotier/zeronsd/releases)，请自行替换下面指令为最新的安装包。

   ```shell
   wget https://github.com/zerotier/zeronsd/releases/download/v0.1.7/zeronsd_0.1.7_amd64.deb
   sudo dpkg -i zeronsd_0.1.7_amd64.deb
   ```

   >如果默认发布的地方没有对应平台的安装包，可以通过Cargo自行编译安装
   >
   >```shell
   >sudo /usr/bin/apt-get -y install net-tools librust-openssl-dev pkg-config cargo
   >sudo /usr/bin/cargo install zeronsd --root /usr/local
   >```

2. 对于你希望启用DNS服务的网络，执行类似以下的命令：

   >`/var/lib/zerotier-one/token`为token文件所在路径 （在上文设置token中有提及）
   >
   >`beyond.corp`为你希望的域名后缀
   >
   >`af78bf94364e2035`为你自己的网络ID

   ```shell
   sudo zeronsd supervise -t /var/lib/zerotier-one/token -w -d beyond.corp af78bf94364e2035
   sudo systemctl start zeronsd-af78bf94364e2035
   sudo systemctl enable zeronsd-af78bf94364e2035
   ```

### 检查可用性

#### 网络需求

* 服务器需要开放53端口，让客户端可以请求到DNS
* 客户端需要启用`Allow DNS`的选项（安卓等平台默认启用，可以无视）

#### 连通性检查

​    假设笔记本的设备名为`laptop`，那么此时就可以通过设备名和dns后缀`ping`通设备了（不考虑防火墙）

```bash
PS C:\Users\AzureBird> ping laptop.beyond.corp

正在 Ping zephy.sak [172.28.120.138] 具有 32 字节的数据:
来自 172.28.120.138 的回复: 字节=32 时间<1ms TTL=128
来自 172.28.120.138 的回复: 字节=32 时间<1ms TTL=128
来自 172.28.120.138 的回复: 字节=32 时间<1ms TTL=128
来自 172.28.120.138 的回复: 字节=32 时间<1ms TTL=128
```

#### 指令更新

​    如果后续需要更新配置（比如TLD），使用类似如下指令即可。（记得修改为自己设置的ID等参数）:

```shell
sudo zeronsd supervise -t /var/lib/zerotier-one/token -w -d beyond.corp af78bf94364e2035
sudo systemctl daemon-reload
sudo systemctl enable zeronsd-af78bf94364e2035
```

## 额外说明

​    `ZeroNSD`还可以添加本地的`hosts`作为私有的DNS服务，不过由于该部分内容并不复杂，且属于进阶内容，故不做教程，此贴仅作入门参考使用的快速手册。
