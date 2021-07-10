---
layout: article
title: WLS2下网络代理的配置
tag: WSL
---

参考链接：
1. [为WSL2一键设置代理](https://zhuanlan.zhihu.com/p/153124468)

# 配置代理

> 在WSL2中，网络不是和WSL1一样直接共享了网路端口，所以需要找到Windows上对应的IP地址，并且设置对应的代理模式

1. 查询DNS服务器IP

   ```shell
   cat /etc/resolv.conf
   ```

2. 设置全局代理的变量

   ```shell
   export ALL_PROXY="http://${host_ip}:${port}"
   ```

# 配置一键脚本

1. 编辑`bash`脚本`proxy.sh`

   ```shell
   #!/bin/bash
   host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
   export ALL_PROXY="http://$host_ip:7890"  # 在Clash中默认端口为7890，按具体情况修改
   ```

2. 使用`source`命令配置当前命令行的代理

   ```shell
   source proxy.sh
   ```

   