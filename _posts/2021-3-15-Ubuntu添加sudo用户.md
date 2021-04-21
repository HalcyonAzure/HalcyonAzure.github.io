---
layout: article
title: "Ubuntu下创建拥有sudo权限的user"
date: 2021-3-15 
description: "创建非root用户，通过sudo来操作一些必要操作"
tag: Ubuntu-小问题
---

1. 添加用户

   `sudo adduser suername`

2. 添加sudo权限

   `sudo usermod -G sudo username`

3. 添加root权限

   如果要让此用户拥有root权限，执行命令

   ```
sudo chmod 777 /etc/sudoers
   sudo vim /etc/sudoers
```
   
---
   
   修改
   
\# User privilege specification
   
   root ALL=(ALL) ALL
   
   username ALL=(ALL) ALL
   
   然后保存退出

4. 修改sudoers的权限

   `sudo chmod 644 /etc/sudoers`