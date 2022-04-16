---
layout: article
title: "不同服务器配置不同SSH密钥登入引导"
date: 2021-05-09 10:00:00
categories: 小技巧
tags: Linux
---

## 参考文章

1. [多个id_rsa 配置](https://blog.csdn.net/xie_zhongyong/article/details/51994389)

## 步骤

1. 在`/.ssh/`目录下新建`config`文件

2. 写入格式类似如下的文件

   ```yaml
   Host github.com
       HostName github.com
       User root
       IdentityFile /.ssh/id_rsa_git
   
   Host test.com
       HostName test.com
       User test
       IdentityFile /.ssh/id_rsa_test
   ```

3. 对于不配置的`Host`，系统会默认使用`id_rsa`文件
