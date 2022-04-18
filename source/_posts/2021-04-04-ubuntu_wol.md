---
layout: post
title: Linux配置局域网下网络唤醒
categories: 小技巧
tags: Linux
abbrlink: 12aa3ef8
date: 2021-04-04 10:00:00
---

1. 安装网络管理工具

   `sudo apt install ethtool`

2. 查询网口信息

   `ip a`

   记录需要启动的网口名字

3. 通过指令手动启动wol服务

   `ethtool -s [INTERFACE] wol g`

4. 查询是否成功

   `ethtool [INTERFACE]`

   输出信息中如果显示`wol:g`则代表开启成功

5. 创建开机进程

   `sudo vi /etc/systemd/system/wol.service`

6. 写入以下内容

   ```bash
   [Unit]
   Description=Configure Wake On LAN
   
   [Service]
   Type=oneshot
   ExecStart=/sbin/ethtool -s [INTERFACE] wol g
   
   [Install]
   WantedBy=basic.target
   ```

7. 载入systemd并启动

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable wol.service
   sudo systemctl start wol.service
   ```

参考博客

1.[WOL持久化设置](https://my.oschina.net/u/4408675/blog/4450878)
