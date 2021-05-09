---
layout: article
title: "配置多个id_rsa文件进行SSH连接"
tag: Linux Security
---

# 参考文章

1. [多个id_rsa 配置](https://blog.csdn.net/xie_zhongyong/article/details/51994389)

# 步骤

1. 在`/.ssh/`目录下新建`config`文件

2. 写入格式类似如下的文件

   ```
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

