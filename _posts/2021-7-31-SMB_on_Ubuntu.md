---
layout: article
title: "搭建smb服务器来浏览离线下载的文件"
date: 2021-7-31
descripiton: "搭建smb服务来达到直接使用文件的目的"
tag: Ubuntu
---

# 安装服务

1. 更新软件

   ```shell
   sudo apt-get upgrade 
   sudo apt-get update 
   sudo apt-get dist-upgrade
   ```

2. 安装samba服务器

   ```shell
   sudo apt-get install  samba  samba-common
   ```

3. 创建一个用于分享的samba文件夹

   ```shell
   sudo mkdir /mnt/Files
   ```

4. 给这个文件夹设置权限

   ```shell
   sudo chmod 777 /mnt/Files
   ```

5. 给需要连接的用户设置密码(非root)

   ```shell
   sudo smbpasswd -a [username]
   ```

6. 配置smb文件

   ```shell
   sudo vi /etc/samba/smb.conf
   ```

   在配置文件最后添加类似以下模板

   ```shell
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

   ```shell
   sudo ufw disable 
   sudo ufw status //查看ufw状态
   ```

8. 重启smb服务器

   ```shell
   sudo service smbd restart
   ```

9. 安装完毕，在Windows+R下连接

   ```
   按Windows+R，然后输入"\\IP地址"检查是否能连接
   ```




# 补充说明 Q&A

* Samba无法访问软链接，提示没有权限

  * 和权限没有关系，需要修改的是`[global]`当中的设置，添加以下三行代码即可

    ```shell
    wide links = yes
    symlinks = yes
    unix extensions = no
    ```

    

  

