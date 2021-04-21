---
layout: post
title: "搭建smb服务器来浏览离线下载的文件"
date: 2021-3-18
descripiton: "搭建smb服务来达到直接使用文件的目的"
tag: Ubuntu-Server-Tools
---

本文参考博客：[地址](https://blog.csdn.net/u012308586/article/details/105555737?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-0&spm=1001.2101.3001.4242)

1. 更新软件

   ```
   sudo apt-get upgrade 
   sudo apt-get update 
   sudo apt-get dist-upgrade
   ```

   

2. 安装samba服务器

   ```bsh
   sudo apt-get install  samba  samba-common
   ```

3. 创建一个用于分享的samba文件夹

   `sudo mkdir /mnt/Files`

4. 给这个文件夹设置权限

   `sudo chmod 777 /mnt/Files`

5. 给需要连接的用户设置密码(非root)

   `sudo smbpasswd -a [username]`

6. 配置smb文件

   ```bsh
   sudo vi /etc/samba/smb.conf
   ```

   在配置文件最后添加类似以下模板

   ```
   [shareFolderName]
   comment = Commit
   #是否能浏览
   browseable = yes
   #路径
   path = /path
   create mask = 0777
   directory mask = 0777
   valid users = [username]
   force user = root 
   #确保有root文件修改权限
   force group = root
   #是否公开
   public = yes
   available = yes
   writable = yes
   # 不允许guest
   guest ok = no
   ```

7. (可选)关闭Ubuntu 防火墙

   ```
   sudo ufw disable 
   sudo ufw status //查看ufw状态
   ```

8. 重启smb服务器

   ```
   sudo service smbd restart
   ```

9. 安装完毕，在Windows+R下连接

   ```
   按Windows+R，然后输入"\\IP地址"检查是否能连接
   ```

   