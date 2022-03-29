---
layout: article
title: "开启TCP BBR算法"
tag: Linux
---

参考文章：[How to enable BBR on Ubuntu 20.04](https://wiki.crowncloud.net/?How_to_enable_BBR_on_Ubuntu_20_04)

## 拥塞控制算法

默认情况下Linux 使用 Reno 和 CUBIC 拥塞控制算法，Linux kernal 4.9以上版本的内核已经自带该功能，由于Ubuntu 20.04的为5.4.0 kernel，我们可以直接启用

通过以下指令检查目前可选择的拥塞控制算法：

```shell
sysctl net.ipv4.tcp_available_congestion_control
```

输出大致为（可用的算法有reno和cubic两种）：

```shell
root@vps:~## sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = reno cubic
```

通过以下指令检查目前的拥塞控制算法：

```shell
sysctl net.ipv4.tcp_congestion_control
```

输出大致为（目前是cubic)：

```shell
root@vps:~## sysctl net.ipv4.tcp_congestion_control
net.ipv4.tcp_congestion_control = cubic
```

## 在Ubuntu中启用TCP BBR

1. 在文件`etc/sysctl.conf`中写入以下内容：

   ```shell
   net.core.default_qdisc=fq
   net.ipv4.tcp_congestion_control=bbr
   ```

   保存并退出
2. 重置`sysctl`设置

   ```shell
   sudo sysctl -p
   ```

   此时会有大致输出：

   ```shell
   root@vps:~## sysctl -p
   net.core.default_qdisc = fq
   net.ipv4.tcp_congestion_control = bbr
   ```

3. 检查BBR是否在系统中正确启用：

   ```shell
   sysctl net.ipv4.tcp_congestion_control
   ```

   大致输出：

   ```shell
   root@vps:~## sysctl net.ipv4.tcp_congestion_control
   net.ipv4.tcp_congestion_control = bbr
   ```

完成
