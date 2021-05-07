---
layout: article
title: "解决路由器重启后ZeroTier的设备ID重新分配的问题"
tag: OpenWrt_Tools
---

# 原因

​	每次重启Openwrt后，ZeroTier的虚拟网卡MAC地址会改变。导致网站后台认为是一台新设备，重新分配设备ID。

# 解决方法

 1. 通过SSH登入服务器

 2. 输入以下指令

    ```shell
    cp -a /var/lib/zerotier-one /etc/zerotier
    ```

	3. 修改`/etc/config/zerotier`的配置文件，加入以下内容

    `option config_path '/etc/zerotier'`