---
layout: article
title: "Linux下通过硬盘UUID进行挂载"
date: 2021-05-22
categories: 小技巧
tags: Linux
---

## 参考链接

1. [重启后盘符发生变化解决办法](https://support.huaweicloud.com/ecs_faq/ecs_faq_1125.html)

## 步骤

1. 将硬盘接入系统

2. 使用以下指令查询目前磁盘分区的盘符

   ```shell
   df -h
   ```

3. 使用以下指令查询特定盘符的UUID

   ```shell
   blkid /dev/sda1  ## 这里的sda1要看具体情况填
   ```

4. 在`/etc/fstab/`内编辑类似以下内容挂载磁盘

   ```shell
   UUID=c26cfce4-xxxx-xxxx-xxxx-403439946c8c    /opt    ext4    defaults 0 0  ## /opt为具体挂载的目录,ext4为磁盘格式
   ```

5. 使用以下指令检查是否设置成功，如果成功则不会返回任何异常信息

   ```shell
   mount -a
   ```
