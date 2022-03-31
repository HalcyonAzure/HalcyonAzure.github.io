---
layout: article
title: "【脚本】Frpc手动安装引导"
date: 2021-03-14
categories: 安装引导
tags:  Frp
---

---

> 部署Frpc并没有找到类似Frps的一键安装脚本，所以只好自己总结安装并启用Frpc的指令，以备不时之需。

1. 首先，在 [fatedier/frp](https://github.com/fatedier/frp/releases/)中下载最新版的frp打包程序，以下以0.35.1版本为例

   ```sh
   wget https://github.com/fatedier/frp/releases/download/v0.35.1/frp_0.35.1_linux_amd64.tar.gz
   tar -xvf frp_0.35.1_linux_amd64.tar.gz
   rm frp_0.35.1_linux_amd64.tar.gz
   ```

2. 首先切换到frp的目录下，把frpc和配置文件放于service对应的目录下

   ```sh
   cd frp_0.35.1_linux_amd64
   sudo mv frpc /usr/bin
   sudo chmod 755 /usr/bin/frpc 
   sudo mkdir /etc/frp
   sudo mv frpc.ini /etc/frp 
   ```

3. 之后通过指令编辑frpc.ini

   `sudo vi /etc/frp/frpc.ini`

4. 之后，切换到services的目录下，将frpc.service移动到系统的systemctl进程守护下，并启用权限

   ```sh
   cd ./systemd
   sudo mv frpc.service /usr/lib/systemd/system
   sudo chmod 644 /usr/lib/systemd/system/frpc.service
   sudo mv frpc@.service /usr/lib/systemd/system
   sudo chmod 644 /usr/lib/systemd/system/frpc@.service
   ```

5. 配置文件就结束了之后只需要直接启用和启动frpc即可

   ```sh
   sudo systemctl enable frpc
   sudo systemctl start frpc
   ```

6. 另外由于不需要配置frps服务，可以回到上级目录并把下载的文件全部删除

   ```sh
   cd ~
   rm -rf frp_0.35.1_linux_amd64
   ```
