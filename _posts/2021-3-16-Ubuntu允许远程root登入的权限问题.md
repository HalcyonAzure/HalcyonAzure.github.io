---
layout: article
title: "Ubuntu下开启root用户的远程连接权限"
date: 2021-3-16
description: "在Ubuntu下启用root的远程ssh权限"
tag: Ubuntu-小问题
---
在租了VPS之后，有的时候（包括自己安装完毕一个Ubuntu镜像以后）会发现自己只能ssh连接到普通账户，如果ssh连接到root用户则会提示Permission Denied或者类似的字样，以下为解决办法。
1. 拥有sudo权限的普通用户登入
2. 输入以下指令
    `sudo vi /etc/ssh/sshd_config`
3. 将
    `#PermitRootLogin prohibit-password`
    修改为
    `PermitRootLogin yes`
4. 然后重启服务器即可