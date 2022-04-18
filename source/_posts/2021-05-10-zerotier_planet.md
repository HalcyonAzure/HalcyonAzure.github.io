---
layout: post
title: ZeroTier搭建Planet服务器引导
categories: 安装引导
tags: ZeroTier
abbrlink: 1e0fb80b
date: 2021-05-10 10:00:00
---

## 参考文章

1. [Running MPLS over ZeroTier Part 1 · Gotz Networks](https://gotz.co/2019/02/17/mpls-over-zerotier-pt-1/)

## 步骤

1. 把ZeroTier的项目在本地克隆一份

   ```shell
   git clone https://github.com/zerotier/ZeroTierOne.git
   ```

2. 打开在`attic`文件夹下的`world`文件夹

   ```shell
   cd ZeroTierOne/attic/world
   ```

3. 编辑`mkworld.cpp`文件，把`ZeroTier Controller默认的IP删除，添加自己的IP上去。`

4. 编译文件

   ```shell
   source ./build.sh
   ```

5. 运行`mkworld`文件

   ```shell
   ./mkworld
   ```

6. 应该会产生一个新的`world.bin`文件，这个文件需要在所有自己的客户端添加

7. 将这个`world.bin`文件复制到`ZeroTier`的文件夹下，在Linux中的指令为

   ```shell
   cp world.bin /var/lib/zerotier-one/planet
   ```

8. 重启`ZeroTier`

   ```shell
   sudo systemctl restart zerotier-one.service
   ```

9. 重复第七步和第八步，在所有希望使用自己`Planet`服务器的客户端中添加这个节点

## 实现的效果

​    完全使用自己的服务器，数据等不通过ZeroTier自己的官网。
