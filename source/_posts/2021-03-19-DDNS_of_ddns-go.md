---
layout: article
title: "DDNS配置"
tag: DDNS
---

本文脚本来源：[ddns-go]([jeessy2/ddns-go: 简单好用的DDNS。自动更新域名解析到公网IP(支持阿里云、腾讯云dnspod、Cloudflare、华为云) (github.com)](https://github.com/jeessy2/ddns-go))

1. 在脚本来源的[release版本](https://github.com/jeessy2/ddns-go/releases)中下载对应版本的ddns-go

2. 将脚本上传到服务器内，然后通过以下命令安装

   ```bsh
   sudo ./ddns-go -s install
   ```

3. 在`http://ip:9876`里面进行配置即可
