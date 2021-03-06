---
layout: article
title: "VPS上一键部署Frps服务"
date: 2021-3-14
description: "通过一键脚本来安装Frps服务"
tag: Frp
---

---

> 在部署Frpc的时候需要自己添加service等到systemctl的目录下，过于麻烦，偶然间发现Frps的服务有一键部署脚本，记录一下方便以后自己查阅并使用

1. 首先，运行这个一键脚本需要wget，curl和tar至少三个依赖，在部分配置极低或者版本极老的系统中并没有，需要自己手动安装:

   `sudo apt update && sudo apt install -y wget curl tar`

2. 安装完毕之后直接运行[MvsCode的脚本](https://github.com/MvsCode/frps-onekey)即可

   ```
   wget https://raw.githubusercontent.com/MvsCode/frps-onekey/master/install-frps.sh -O ./install-frps.sh
   chmod 700 ./install-frps.sh
   ./install-frps.sh install
   ```

3. 之后根据提示，国内VPS使用aliyun安装，国外VPS使用github安装，并且配置好Frps的端口，dashboard的端口还有对应的token，其他选项在端口没有冲突的情况下直接使用默认即可。
4. 安装完毕以后通过指令`frps start`就可以成功运行了。

5. (选看)之前在CentOS上配置Frps以后，发现Frpc并不能正常连接，结果发现应该问题是出于防火墙，由于穿透只是用于自己学习需求，所以暂时采取直接关闭防火墙的方式，具体指令如下:

   ```
   systemctl stop firewalld.service
   systemctl disable firewalld.service
   ```

   结果在关闭防火墙以后发现依旧出现有的连接不能正常启动的情况，再次查阅log发现问题出于Frpc连接设置重名，所以只需要设置**不同的Frpc端口穿透名字不同**即可