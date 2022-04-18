---
layout: post
title: "Linux下通过swap或zram管理内存"
date: 2021-03-25 10:00:00
categories: 小技巧
tags: Linux
---

参考网址:
1.[Ubuntu开启zram和zswap~](https://imhy.zbyzbyzby.com/wordpress/?p=815)
2.[使用zram进行内存压缩](https://blog.gloriousdays.pw/2018/11/30/memory-compress-using-zram/)
3.[Ubuntu添加swap分区](https://www.jianshu.com/p/498858f8d704)

## 创建Swap分区

>Swap分区在系统的物理内存不够用的时候，把物理内存中的一部分空间释放出来，以供当前运行的程序使用。那些被释放的空间可能来自一些很长时间没有什么操作的程序，这些被释放的空间被临时保存到Swap分区中，等到那些程序要运行时，再从Swap分区中恢复保存的数据到内存中。
>
>Swap分区虽然可以达到扩大内存的作用，但缺点依旧很明显，相比直接使用物理内存，Swap必然速度上会出现一定的取舍。

1. 新建一个文件夹来作为swap的文件

   ```shell
   mkdir swap
   cd swap
   sudo dd if=/dev/zero of=sfile bs=1024 count=2000000
   ```

   其中`sfile`是文件的名字，可以自己设置，`count=2000000`是Swap分区的大小，这里指2G

2. 转化为swap文件

   `sudo mkswap sfile`

3. 激活swap文件

   `sudo swapon sfile`

4. 查看效果

   `free -m`

   ```shell
                 total        used        free      shared  buff/cache   available
   Mem:            478          61         184           3         233         379
   Swap:          2704           0        2704
   ```

   已经成功挂载了

5. 添加开机加载

   ```bash
   vi /etc/fstab
   ```

   修改配置文件，添加Swap文件(Swap文件的路径为`/root/swap/sfile`)

   `/root/swap/sfile    none            swap    sw        0 0`

   类似如下

   ```shell
   /dev/vda1           /               ext4    defaults  1 1
   /dev/vda2           swap            swap    defaults  0 0
   /root/swap/sfile    none            swap    sw        0 0
   none                /dev/shm        tmpfs   defaults  0 0
   ```

## 使用zram进行内存压缩

>swap空间在机械硬盘的设备上往往不一定是个好选择，这个时候牺牲一定的CPU性能来使用zram则会比较好
>
>zram 是在 Linux Kernel 3.2 加入的一个模块，其功能是在内存中开辟一块空间，用来存储压缩后的内存数据，这样可以在牺牲一定的 CPU Cycle 的情况下，在内存中存储尽量多的数据而不需要写入到磁盘。

1. 安装zram-config，并重启系统

   ```bash
   sudo apt install zram-config
   sudo reboot
   ```

2. 通过zramctl查看zram的情况(默认情况下ALGORITHM为lzo)

   ```bash
   NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
   /dev/zram0 lz4         239.4M   4K   63B    4K       1 [SWAP]
   ```

   > 注意到这里的压缩算法，有两种算法 lzo 和 lz4 可选，默认是 lzo。根据 [Benchmark](https://github.com/lz4/lz4)，lz4 的压缩和解压性能在压缩率和 lzo 持平的情况下显著高于后者，因此我们应该采用 lz4 而非 lzo 以获得更高的系统效率。

3. 修改配置文件来使用lz4算法

   `usr/bin/init-zram-swapping`

   将源文件的以下部分

   ```shell
   ## initialize the devices
   for i in $(seq ${NRDEVICES}); do
     DEVNUMBER=$((i - 1))
     echo $mem > /sys/block/zram${DEVNUMBER}/disksize
     mkswap /dev/zram${DEVNUMBER}
     swapon -p 5 /dev/zram${DEVNUMBER}
   done
   ```

   替换为

   ```shell
   ## initialize the devices
   for i in $(seq ${NRDEVICES}); do
     DEVNUMBER=$((i - 1))
     echo lz4 > /sys/block/zram${DEVNUMBER}/comp_algorithm
     echo $mem > /sys/block/zram${DEVNUMBER}/disksize
     mkswap /dev/zram${DEVNUMBER}
     swapon -p 5 /dev/zram${DEVNUMBER}
   done
   ```

4. 载入新的配置

   `systemctl restart zram-config`

## 开启ZSwap

1. 编辑grub文件

   `sudo vi /etc/default/grub`

2. 在文件末尾加上

   ```shell
   GRUB_CMDLINE_LINUX=”zswap.enabled=1″
   ```

   保存退出

3. 在终端输入命令

   `sudo update-grub`

4. 重启系统

> zswap是一种新的轻量化后端构架，将进程中正交换出的页面压缩，并存储在一个基于RAM的内存缓冲池中。除一些为低内存环境预留的一小部分外，zswap缓冲池不预先分配，按需增加，最大尺寸可用户自定义。
>
> Zswap启动存在于主线程中的一个前端，称为frontswap，zswap/frontswap进程在页面真正交换出之前监听正常交换路径，所以现有的交换页面选择机理不变。
>
> Zswap也引入重要功能，当zswap缓冲池满时自动驱除页面从zswap缓冲池到swap设备。防止陈旧页面填满缓冲池。
