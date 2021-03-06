---
layout: article
title: "Linux挂载WebDav硬盘"
tag: WebDav
---

# 参考

1. [davfs挂载与使用缺陷](https://blog.csdn.net/u013401853/article/details/113094734)

# 安装

1. 输入以下指令安装

   ```shell
   sudo apt install davfs2
   ```

# 连接

1. 创建需要挂载的硬盘，这里以`/opt/Backup`为例，挂载网址为`http://localhost:8080/dav/`，账号为`admin`，密码为`123456`

   ```
   mkdir /opt/Backup/
   ```

2. 将硬盘挂载到对应路径

   ```shell
   sudo mount.davfs http://locaohost:8080/dav/ /opt/Backup/
   ```

3. 输入账号密码并手动连接

# 保存密码

1. 编辑`/etc/davfs2/davfs2.conf`，找到其中的`use_lock`取消注释，并修改值为`0`

2. 修改`/etc/davfs2/secrets`，在末尾添加

   ```shell
   http://localhost:8080/dav/ admin 123456
   ```

# 自动挂载

1. 编辑`/etc/fstab`，在最后一行添加以下内容

   ```shell
   http://localhost:8080/dav/ /opt/Backup/ davfs defaults 0 0
   ```

   

> 以上的http://localhost:8080/dav/和用户名密码均为示例，请在了解WebDav之后替换为自己需要的值