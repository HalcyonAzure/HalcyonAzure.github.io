---
layout: article
title: "拓展Ubuntu服务器LVM分区"
tag: Linux
---

> 参考文章：[解决 Linux /dev/mapper/ubuntu--vg-ubuntu--lv 磁盘空间不足的问题](https://blog.csdn.net/Fly_1213/article/details/105142427)

1. 通过命令查看LVM卷组的信息

   ```sh
   root@azhal:/mnt/Ar2D# vgdisplay
     --- Volume group ---
     VG Name               ubuntu-vg
     System ID
     Format                lvm2
     Metadata Areas        1
     Metadata Sequence No  2
     VG Access             read/write
     VG Status             resizable
     MAX LV                0
     Cur LV                1
     Open LV               1
     Max PV                0
     Cur PV                1
     Act PV                1
     VG Size               <930.01 GiB
     PE Size               4.00 MiB
     Total PE              238082
     Alloc PE / Size       51200 / 200.00 GiB
     Free  PE / Size       186882 / <730.01 GiB
   ```

2. 可以看到可扩容大小

   `Free  PE / Size       186882 / <730.01 GiB`

3. 使用命令进行扩容

   按不同需求有以下命令:

   ```sh
   lvextend -L 10G /dev/mapper/ubuntu--vg-ubuntu--lv      //增大或减小至19G
   lvextend -L +10G /dev/mapper/ubuntu--vg-ubuntu--lv     //增加10G
   lvreduce -L -10G /dev/mapper/ubuntu--vg-ubuntu--lv     //减小10G
   lvresize -l  +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv   //按百分比扩容
   
   resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv            //执行调整
   ```

   具体操作:

   ```sh
   root@azhal:/mnt/Ar2D# lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
     Size of logical volume ubuntu-vg/ubuntu-lv changed from 200.00 GiB (51200 extents) to <930.01 GiB (238082 extents).
     Logical volume ubuntu-vg/ubuntu-lv successfully resized.
   root@azhal:/mnt/Ar2D# resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
   resize2fs 1.45.5 (07-Jan-2020)
   Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
   old_desc_blocks = 25, new_desc_blocks = 117
   The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 243795968 (4k) blocks long.
   ```

4. 检查是否扩容成功

   ```sh
   root@azhal:/mnt/Ar2D# vgdisplay
     --- Volume group ---
     VG Name               ubuntu-vg
     System ID
     Format                lvm2
     Metadata Areas        1
     Metadata Sequence No  3
     VG Access             read/write
     VG Status             resizable
     MAX LV                0
     Cur LV                1
     Open LV               1
     Max PV                0
     Cur PV                1
     Act PV                1
     VG Size               <930.01 GiB
     PE Size               4.00 MiB
     Total PE              238082
     Alloc PE / Size       238082 / <930.01 GiB
     Free  PE / Size       0 / 0
   ```

   可以看到Free Size已经变成0，即扩容成功。
