---
layout: article
title: "Rclone同步脚本[作废]"
tag: Linux
---

> 大半年回头看发现好多需求都是自己太无知了...文件校验这种东西在Rclone或者Rsync都已经有了，而且Rclone本身也有sync的功能。

## 需求

​    在家中自己搭建了一个`Seafile`同步服务器后，总是不太放心里面的数据安全。在发现了`Github`上有人写了最新不限速的阿里云盘的`WebDav`实现之后，就萌生了用`WebDav`配合`Shell脚本`以及`Sync`、`Rclone`三个工具实现“本地一份”和“云端一份”的备份方式。

## 方案

### 数据布局

* 存储了`Seafile`服务的主硬盘A
* 家中闲置的硬盘B
* 阿里云盘

### 备份方案

​    通过`crontab`来实现计划任务，计划每天凌晨的时候通过`Sync`把主硬盘A中的数据镜像存储在闲置硬盘B中，作为一个本地紧急恢复的拷贝，同时因为`Seafile`储存了重要的密码信息，为了避免丢失，每个礼拜会将硬盘B中的数据先通过`7zip`工具进行压缩，压缩后通过自定义脚本上传到云端服务器，并且检查云端的`SHA1`确保数据完好无误。

>最开始的方案其实是通过Rclone的Sync来备份Seafile中的文件的，但是在实战后发现由于Seafile的文件大多是小体量的数据块，在文件太多的时候出于未知原因，无法直接将整个所有的文件夹下载下来用于备份，考虑到云端备份用到的概率较低，也不太需要实时读取，所以采用了先压缩后上传的方式备份。

## 主要难点

* **对于`Shell`语法生疏**
* `Rclone`不熟悉
* 远端文件的`SHA1`获取
* ~~移动突然这几天把家里300M上行的网络限速到稳定30M不到，每次想测试大文件备份就要等半天~~

## 步骤

1. 安装`Rsync`和`Rclone`

   > 直接通过包管理器直接安装即可

2. 通过`crontab`设置`Rsync`的同步脚本，在每天凌晨的时候将硬盘A的数据备份至硬盘B中，其中忽略不重要的`.log`等文件，类似指令如下

   ```shell
   rsync -avz --delete --exclude='*.log*' /opt/seafile-data /opt/seafile-mysql /opt/seafile-elasticsearch /mnt/files/Seafile
   ```

   > 关于如何使用`Rsync`在之前的博客有发：[Rsync学习记录](https://halc.top/2021/08/04/Rsync_Manual.html)

3. 通过`Docker`部署阿里云盘的`WebDav`，使用的库来源于：[zxbu/webdav-aliyundriver：的webdav协议开源实现](https://github.com/zxbu/webdav-aliyundriver)

   > `Docker`的使用之前的博客有发：[Docker使用手册](https://halc.top/2021/07/22/Docker-Command.html)

4. 通过指令配置Rclone，对文件进行直接上传、下载、检查等操作

   > `Rclone`的学习使用还未出炉，先TODO，这里跳过具体操作，直接假设已经配置好了一个config为Aliyun

5. 编写对应的`Shell`脚本来做到上传和校对的工作，同样通过`crontab`定时执行，脚本如下：

   **如果要使用脚本，先确定自己`Rclone`已经挂载，并且脚本内的`Rclone的信息`正确配置为自己需要的内容**

   ```shell
   #!/bin/sh
   
   ## 忽略echo和printf的提醒
   ## shellcheck disable=SC3000-SC4000
   
   #######################################################################
   ##  作者: HalcyonAzure
   ##  时间: 2021-8-5
   ##  将自定义目录下的文件夹打包，并上传到Rclone配置服务器中，并在上传完成后校验SHA1值
   ##  成功：本地打包文件删除，只保留远端文件
   ##  失败：删除远端文件，并重试三次，没有成功将保留本地文件，删除远端错误文件
   #######################################################################
   
   ## 彩色字体
   Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Font_color_suffix="\033[0m"
   Info="${Green_font_prefix}[信息]${Font_color_suffix}"
   Error="${Red_font_prefix}[错误]${Font_color_suffix}"
   #
   
   ## Rclone的信息
   RcloneConfig="Aliyun"
   RemotePath="/Backup/Test"
   BackupPath="/mnt/files"
   BackupFolder="backup_test"
   
   ## 备份的压缩包名字
   BackupZip="${BackupFolder}-$(date +%F-%H-%M).7z"
   
   ## 压缩备份路径
   7za a -t7z -r "$BackupPath"/"$BackupZip" "$BackupPath"/"$BackupFolder"
   echo -e "${Info}文件压缩完毕"
   
   ## 生成文件的sha1文件
   ## sha1sum "$BackupZip" >"$BackupZip".sha1
   
   ## 将文件转移到Rclone中
   Upload_Bak() {
       echo -e "${Info}开始上传..."
       ## retries是指上传失败以后重试的次数，Buffer-size是缓存，这里可以调小一点，512M为示例
       if ! rclone copy --retries=1 --buffer-size=512M "$BackupPath"/"$BackupZip" "$RcloneConfig:$RemotePath"; then
           echo -e "${Error}上传失败!"
           exit 1
       fi
       echo -e "${Info}上传文件成功，3s后开始校验信息"
       ## 停止3s，避免因为频繁使用io被禁用
       sleep 3s
   }
   
   ## 尝试次数初始化
   TryCounters=1
   #校验转移后文件的sha1值是否符合，只会尝试三次，否则退出脚本（zxbu的库中WebDav不校验文件）
   Check_Sha1() {
       ## 生成校验信息
       echo -e "${Info}开始校验信息..."
       LocalSHA1="$(sha1sum "$BackupPath"/"$BackupZip")"
       LocalSHA1="${LocalSHA1:0:39}"
       echo -e "${Info}本地校验信息：$LocalSHA1"
       RemoteSHA1="$(rclone sha1sum "$RcloneConfig":"$RemotePath"/"$BackupZip" --download)"
       RemoteSHA1="${RemoteSHA1:0:39}"
       echo -e "${Info}远端校验信息：$RemoteSHA1"
       ## 对比校验信息
       if [ "$LocalSHA1" = "$RemoteSHA1" ]; then
           #删除本地的备份文件
           rm "$BackupPath"/"$BackupZip"
           echo -e "${Info}校验成功！删除本地备份"
       else
           echo -e "${Error}上传校验失败，删除远端文件并重新上传"
           echo -e "${Info}开始删除文件"
           rclone delete "$RcloneConfig":"$RemotePath"/"$BackupZip"
           echo -e "${Info}删除完毕，3s后开始进行重新上传"
           sleep 3s
           #删除远端的备份文件，并且重新上传后检查sha1
           TryCounters=$((TryCounters + 1))
           if [ $TryCounters -gt 3 ]; then
               echo -e "${Error}上传三次均失败，请检查网络环境"
               exit 3
           else
               echo -e "${Info}开始第${TryCounters}次上传"
               Upload_Bak
               Check_Sha1
           fi
       fi
   }
   
   Upload_Bak
   Check_Sha1
   
   echo -e "${Info}备份脚本完成"
   exit 0
   ```

   >Shell大概看了两三天的时间，里面有些格式和规范还需要调整，日后再对脚本进行优化一下
