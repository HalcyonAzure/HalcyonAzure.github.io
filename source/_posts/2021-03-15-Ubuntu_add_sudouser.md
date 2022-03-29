---
layout: article
title: "创建sudo用户"
tag: Linux
---

1. 添加用户

   `sudo adduser suername`

2. 添加sudo权限

   `sudo usermod -G sudo username`

3. 添加root权限

   如果要让此用户拥有root权限，执行命令

   ```shell
   sudo chmod 777 /etc/sudoers
   sudo vim /etc/sudoers
    ```

   修改

   ```shell
   # User privilege specification
   
   root ALL=(ALL) ALL
   
   username ALL=(ALL) ALL
   ```

   然后保存退出

4. 修改sudoers的权限

   `sudo chmod 644 /etc/sudoers`
