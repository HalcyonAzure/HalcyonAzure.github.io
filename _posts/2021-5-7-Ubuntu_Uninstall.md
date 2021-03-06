---
layout: article
title: Ubuntu下apt清理软件残余
tag: Ubuntu
---

# 参考网站

1. [Ubuntu删除无用缓存及垃圾文件](https://blog.csdn.net/yanzi1225627/article/details/9269279)

# 常用的清理指令

```shell
sudo apt-get autoclean  # 清理旧版本的软件缓存
sudo apt-get clean  # 清理所有软件缓存
sudo apt-get autoremove  # 删除系统不再使用的孤立软件
```

这三个指令主要是用于清理升级时候产生的缓存和无用的包

# 包管理的临时文件目录

* 包在`/var/cache/apt/archives`
* 没有下载完毕的在`/var/cache/apt/archives/partial`

# 卸载软件

```shell
sudo apt-get remove --purge [软件名字]  # 卸载某个软件
dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P  # 删除系统上多余的配置文件
```

# 删除内核

​	见博客：[删除多余的Ubuntu内核,解决因grub无法正常启动的问题](https://halc.top/2021/04/24/Ubuntu删除Grub内多余内核.html)

