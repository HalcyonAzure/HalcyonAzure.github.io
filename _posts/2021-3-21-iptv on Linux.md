---
layout: article
title: "通过脚本在Linux上运行ncu的iptv"
date: 2021-3-21
descripition: "通过脚本来避免flash运行iptv来达到凑时间的目的"
tag: NCU_Tools
---

> 由于学校（南昌大学）要求每个月必须看满五个小时的iptv，并且iptv直接在浏览器上观看是需要安装flash或者包含flash的浏览器的。而如今flash的末路使得不少人头疼，在github上偶然发现有学长用go语言编写了一个脚本，在这里记录一下在Linux上的使用过程。

0. 脚本来源 [南昌大学IPTV](https://github.com/shuwenwei/iptv-helper) 

1. 获取脚本并进行编译

   ```bsh
   git clone https://github.com/shuwenwei/iptv-helper.git
   cd iptv-helper/
   ```
   
2. 安装编译go的库依赖

   ```
   sudo apt update && sudo apt install golang-go
   ```
   
3. 编译文件并设置权限

   ```
   go build main.go
   go build -o iptv
   chmod 777 iptv
   ```

4. 通过screen在后台运行脚本

   ```
   sudo apt install screen
   screen -R iptv
   ```

5. 编辑iptv.toml为自己的信息

   `vi iptv.toml`

   修改为自己的信息

   ```
   [user]
   #用户名
   Username = "[username]"
   #密码
   Password = "[password]"
   [app]
   #每个goroutine观看的时间(分钟)
   Tasktime = 10
   #同时观看数量(goroutine数), 总播放时间 = Tasknum * Tasktime
   Tasknum = 10
   ```
   
6. 保存文件，并在对应的screen下运行

   ```
   ./iptv
   ```
