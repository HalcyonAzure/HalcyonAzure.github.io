---
layout: post
title: "Linux通过fdisk分区引导"
date: 2021-03-25 10:00:00
categories: 小技巧
tags: [Linux, OpenWRT]
---

参考地址：
[CSDN-树莓派Openwrt SD卡扩展问题](https://blog.csdn.net/xjtumengfanbin/article/details/106871591)

​    在给自己的R2S使用64G的SD卡的时候，安装完毕系统启动发现内存卡中有将近50多G的空间没有得到合理的使用，记录一下通过网上树莓派磁盘扩展分区的步骤来在R2S上同样对SD卡进行分区拓展

## fdisk磁盘拓展

1. 磁盘检查

   `df -h`  检查已经使用的磁盘容量

   `fdisk /dev/mmcblk0`  查看磁盘分区，并进行部分操作

2. 检查磁盘分区情况并且进行分区

   在`fdisk`后的`Command( m for help):`后输入`p`来查看分区情况

   ![fdiskp](https://lsky.halc.top/alLijz.png)

   其中可以看到最后分区的`End`为`3817471`

3. 新建磁盘

   输入`n`进行新建磁盘，之后会有几个询问，分别对应以下几点

   * 输入磁盘编码，一般按Default的设置即可
   * 输入扇区的起始位置，这里输入最后一个分区+1的数值大小，比如上图中`End`后为`3817471`，那我这里就输入`3817472`
   * 输入终止扇区，这里可以填入Default设置，就会设置最大可用扇区
   * 输入`w`进行保存

4. 把新建的分区格式化为ext4格式

   `mkfs.ext4 /dev/mmcblk0p3`

5. 分区挂载

   * 方法一
     * 在Openwrt的管理界面的挂载点中，直接使用"自动挂载"进行磁盘的挂载
   * 方法二
     * `mount -v -t ext4 -o rw /dev/mmcblk0p3 [pathToMount]`

6. 通过`df -h`命令查看，可以发现已经挂载成功
