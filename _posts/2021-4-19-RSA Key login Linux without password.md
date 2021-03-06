---
layout: article
title: "Linux使用RSA密钥登入并关闭密码登入"
date: 2021-4-19
description: "通过使用RSA密钥登入，并且关闭明文密码登入加强服务器的安全性"
tag: Linux Security
---

# 生成密钥

1. 在客户端电脑上输入以下指令生成rsa私钥和公钥

   `ssh-keygen -t rsa -C "your@email.com"`

   生成一对以你的邮箱为标签的密钥

2. 在`/.ssh/`文件夹下的`id_rsa`为密钥文件，`id_rsa.pub`为公钥文件

# 在Linux服务器下添加密钥

1. 在当前用户的主目录中的`/.ssh/`中添加或者修改`authorized_keys`文件，将刚刚客户端的`id_rsa.pub`内容复制到`authorized_keys`中

# 关闭密码登入，并且只用RSA登入

1. 编辑`sshd_config`文件

   `vi /etc/ssh/sshd_config`

2. 禁用密码验证

   将`PasswordAuthentication`的注释取消，并修改为

   `PasswordAuthentication no`

3. 启用RSA登入

   ```shell
   RSAAuthentication yes
   PubkeyAuthentication yes
   ```

4. 重启SSH服务

   ​	**注意，重启SSH服务之前建议保留一个会话，以免出现密码登入失败的情况**

   * RHEL/CentOS系统

     `sudo service sshd restart`

   * Ubuntu系统

     `sudo service ssh restart`

   * Debain系统

     `/etc/init.d/ssh restart`



参考文章:

> [SSH使用密钥登入并禁止口令登入实践](https://www.linuxidc.com/Linux/2015-07/119608.htm)