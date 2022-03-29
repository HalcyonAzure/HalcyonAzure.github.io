---
layout: article
title: "Ubuntu切换显卡"
tag: Linux
---

## 参考文章

1. [在Ubuntu 18.04上切换独显/集显 – VOID (rayleizhu.com)](https://rayleizhu.com/?p=156)

## 脚本切换

1. 使用Nvidia独显

   ```shell
   sudo prime-select nvidia
   ```

2. 使用Intel集显

   ```shell
   sudo prime-select intel
   ```

3. 查询当前用的显卡

   ```shell
   prime-select query
   ```
