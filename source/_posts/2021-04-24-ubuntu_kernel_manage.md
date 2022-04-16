---
layout: article
title: "Linux多个不同版本内核卸载管理"
date: 2021-04-24 10:00:00
categories: 小技巧
tags: Linux
---



## Ubuntu删除多余的内核

1. 查看当前的内核

   ```shell
   root@azhal:~## uname -a
   Linux azhal 5.11.16-xanmod1-cacule #0~git20210421.d9591de SMP PREEMPT Wed Apr 21 17:44:04 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
   ```

2. 查看当前系统中所有的内核

   ```shell
   root@azhal:~## dpkg --get-selections |grep linux
   binutils-x86-64-linux-gnu                       install
   console-setup-linux                             install
   libselinux1:amd64                               install
   libselinux1-dev:amd64                           install
   linux-base                                      install
   linux-firmware                                  install
   linux-headers-5.11.16-xanmod1-cacule            install
   linux-image-5.11.16-xanmod1-cacule              install
   linux-image-5.4.0-72-generic                    install
   linux-image-generic                             install
   linux-libc-dev:amd64                            install
   linux-modules-5.4.0-72-generic                  install
   linux-modules-extra-5.4.0-72-generic            install
   linux-xanmod-cacule                             install
   util-linux                                      install
   ```

3. 移除多余的内核

   ```shell
   sudo apt-get remove <name of kernel>
   ```

4. 再次检查内核是否为`deinstall`状态

   ```shell
   dpkg --get-selections |grep linux
   ```

5. 更新系统引导

   ```shell
   sudo update-grub
   ```

参考文章

1. [Ubuntu删除多余的内核 - 阳光与叶子 - 博客园 (cnblogs.com)](https://www.cnblogs.com/yangzhaon/p/12911716.html)
