---
layout: post
title: "Openwrt系统内配置Frpc自启动"
date: 2021-03-20 10:00:00
categories: 安装引导
tags: Frp
---

---

> Frpc在Openwrt上的客户端多多少少有点问题，为了方便自己使用，在这里记录一下如果用命令行启动和编辑Frpc的流程

1. 首先，在 [fatedier/frp](https://github.com/fatedier/frp/releases/)中下载最新版的frp打包程序，以下以0.35.1版本为例

   ```bash
   wget https://github.com/fatedier/frp/releases/download/v0.35.1/frp_0.35.1_linux_amd64.tar.gz
   tar -xvf frp_0.35.1_linux_amd64.tar.gz
   rm frp_0.35.1_linux_amd64.tar.gz
   ```

2. 首先切换到frp的目录下，把frpc和配置文件放于service对应的目录下

   ```bash
   cd frp_0.35.1_linux_amd64
   sudo mv frpc /usr/bin
   sudo chmod 755 /usr/bin/frpc 
   sudo mkdir /etc/frp
   sudo mv frpc.ini /etc/frp 
   ```

3. 之后通过指令编辑frpc.ini

   `sudo vi /etc/frp/frpc.ini`

4. 之后，编辑/etc/init.d/frpc

   ```bash
   #!/bin/sh /etc/rc.common
    
    START=90
    STOP=90
    SERVICE=frpc
    USE_PROCD=1
    PROC="/usr/bin/frpc -c /etc/frp/frpc.ini"
    
    start_service()
    
    {
        procd_open_instance
        procd_set_param command $PROC
        procd_set_param respawn
        procd_close_instance
    
    }
    
    service_triggers()
    {
        procd_add_reload_trigger "rpcd"
    }
    ```

   > 脚本来自[OpenWRT/LEDE下开机脚本](https://juejin.cn/post/6844904014446854158)

5. 配置文件就结束了之后只需要直接启用和启动frpc即可

   ```bash
   /etc/init.d/frp start
   /etc/init.d/frp enable && echo on
   ```

6. 另外由于不需要配置frps服务，可以回到上级目录并把下载的文件全部删除

   ```bash
   cd ~
   rm -rf frp_0.35.1_linux_amd64
   ```
