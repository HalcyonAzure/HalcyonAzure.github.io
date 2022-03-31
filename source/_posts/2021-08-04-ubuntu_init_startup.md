---
layout: article
title: "配置init.d开机自启"
categories: 小技巧
tags:  Linux
---

## 流程

1. 创建脚本文件，这里以`startup.sh`示例

2. 给脚本添加可执行权限，并移动脚本位置

   ```shell
   chmod +x startup.sh
   sudo mv startup.sh /etc/init.d/
   ```

3. 设置为开机脚本

   ```shell
   sudo update-rc.d /etc/init.d/startup.sh defaults 100
   ## 这里的100指的是脚本的优先级，数字越大执行越晚，可以为0
   ```

   如果需要删除脚本，用`remove`即可

   ```shell
   sudo update-rc.d /etc/init.d/startup.sh remove
   sudo rm /etc/init.d/startup.sh
   ```
