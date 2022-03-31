---
layout: article
title: "ZeroTier配置Moon服务器"
categories: 安装引导
tags:  ZeroTier
---

参考链接:
1.[什么值得买-ZeroTier配置Moon节点](https://post.smzdm.com/p/adwrepgk/)

2.[ZeroTier官方手册](https://www.zerotier.com/manual/#4_4)

## 安装Moon服务器的作用

​    ZeroTier本身的PLANET服务器位于国外，并且由于免费的性质以至于在一些高峰时期经常出现无法打通隧道的情况，这个时候通过自己搭建国内的Moon节点并且进行配置可以达到国内中转加速的作用。

## Moon服务器在VPS上的搭建

1. 将需要设置moon节点的VPS加入到需要加速的局域网内

   `zerotier-cli join <network id>`

2. 生成moon模板

   ```bash
   cd /var/lib/zerotier-one
   zerotier-idtool initmoon identity.public > moon.json
   ```

3. 修改moon.json

   `vi moon.json`

   修改`stableEndpoints`为VPS的公网IP，可以添加ipv6地址，例如：

   `"stableEndpoints": [ "10.0.0.2/9993","2001:abcd:abcd::1/9993" ]`

   完整的文件内容示例如下:

   ```bash
   {
     "id": "deadbeef00",
     "objtype": "world",
     "roots": [
       {
         "identity": "deadbeef00:0:34031483094...",
         "stableEndpoints": [ "10.0.0.2/9993","2001:abcd:abcd::1/9993" ]
       },
       {
         "identity": "feedbeef11:0:83588158384...",
         "stableEndpoints": [ "10.0.0.3/9993","2001:abcd:abcd::3/9993" ]
       }
     ],
     "signingKey": "b324d84cec708d1b51d5ac03e75afba501a12e2124705ec34a614bf8f9b2c800f44d9824ad3ab2e3da1ac52ecb39ac052ce3f54e58d8944b52632eb6d671d0e0",
     "signingKey_SECRET": "ffc5dd0b2baf1c9b220d1c9cb39633f9e2151cf350a6d0e67c913f8952bafaf3671d2226388e1406e7670dc645851bf7d3643da701fd4599fedb9914c3918db3",
     "updatesMustBeSignedBy": "b324d84cec708d1b51d5ac03e75afba501a12e2124705ec34a614bf8f9b2c800f44d9824ad3ab2e3da1ac52ecb39ac052ce3f54e58d8944b52632eb6d671d0e0",
     "worldType": "moon"
   }
   ```

4. 生成moon签名文件

   `zerotier-idtool genmoon moon.json`

5. 通过winscp等工具将`000000xxxx.moon`的签名文件拷贝下来，或者记住`moon.json`中`"id": "idtoremember"`的`id`

6. 将moon节点加入网络

   ```bash
   mkdir moons.d
   mv ./*.moon ./moons.d
   ```

7. 重启ZeroTier，到此Moon服务器的配置结束。

## 在客户端启用配置好的节点

### 方法一：通过ID直接加入

1. 在搭建moon服务器的第五步中，记录下moon节点的id，然后在客户端上运行命令

   `zerotier-cli orbit idtoremeber idtoremeber`

### 方法二：通过添加签名文件加入

1. 在不同设备的ZeroTier根目录下添加moons.d文件夹

   ```bash
   其中，不同系统对应的ZeroTier的位置如下：
   Windows: C:\ProgramData\ZeroTier\One
   Macintosh: /Library/Application Support/ZeroTier/One)
   Linux: /var/lib/zerotier-one
   FreeBSD/OpenBSD: /var/db/zerotier-one
   ```

2. 将生成的0000xxx.moon文件放置于moons.d文件夹下

#### Openwrt下ZeroTier配置Moon服务器

> OpenWrt需要修改一个脚本，因为其var目录是一个内存虚拟的临时目录，重启后原有配置不会保留。

1. 通过ssh连接到Openwrt并修改zerotier的启动脚本

   ```bash
   vi /etc/init.d/zerotier
   ```

2. 在`add_join(){}`上方插入两行代码

   ```bash
       mkdir -p $CONFIG_PATH/moons.d
       cp /home/moons.d/* $CONFIG_PATH/moons.d/
   ```

   如下图所示:

   ![ZeroTier的Moon节点](/2021/03/images/ZeroTier_Moon.png)

3. 在/home文件夹下创建moons.d文件夹（修改`cp /home/moons.d`可以修改需要设置的路径）

4. 把moon的签名文件00000xxx.moon放于该文件夹内，并重启ZeroTier即可

##### 补充：解决Openwrt重启后ZeroTier的ID重新分配的问题

1. 启动Openwrt上的ZeroTier

2. 输入以下指令

   ```shell
   cp -a /var/lib/zerotier-one /etc/zerotier
   ```

3. 修改`/etc/config/zerotier`的配置文件，添加以下内容

   `option config_path '/etc/zerotier'`
