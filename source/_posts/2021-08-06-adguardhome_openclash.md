---
layout: article
title: "AdGuardHome与OpenClash兼容配置"
date: 2021-08-06
categories: 小技巧
tags:  OpenWRT
---

## 设置步骤

> 参考[结合adguard home 使用 DNS 设置求教 · Issue #99](https://github.com/vernesong/OpenClash/issues/99)中hankclc和icyleaf的回答，总结一下设置步骤作为参考

1. 将AdGuard Home的上游DNS设置为OpenClash的DNS地址

   >OpenClash的DNS地址可以在全局设置中看到，一般为`127.0.0.1:7874`

2. 关闭OpenClash的本地DNS劫持
3. AdGuard Home的重定向模式选择使用53端口替换dnsmasq

***OpenClash不要用TUN或TUN混合模式（还未自己测试）***
