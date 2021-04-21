---
layout: post
title: "使用CloudFlare的CDN加速Nginx网站出现520"
date: 2021-4-21
description: "CloudFlare的CDN加速Nginx网站出现520报错的解决方案"
tag: Nginx
---



# 出现原因

* 设置了Nginx防火墙，禁止了国外IP访问网站或者有类似的协议导致CDN无法连接上站点。

# 解决方案

* 关闭Nginx防火墙内的"禁止国外访问"，或者添加[CloudFlare的CDN的IP列表](https://www.cloudflare.com/zh-cn/ips/)到防火墙的白名单就行。