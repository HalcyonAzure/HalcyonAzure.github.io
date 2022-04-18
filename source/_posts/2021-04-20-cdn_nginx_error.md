---
layout: post
title: Nginx配置CDN回源重定向导致的无法访问问题
categories: 小技巧
tags:
  - Nginx
  - CDN
abbrlink: a2277ea0
date: 2021-04-20 10:00:00
---

## 前言

​    在部署好了CloudReve和Nginx以后，想通过Cloudflare的免费的CDN服务来达到一个节省流量的目的，但是在直接开启CDN代理之后发现原本的网站一直出现Network Error的问题，在此记录一下解决方案。

​    首先记录一下现状：

* CloudReve部署在自己家的服务器上，通过ZeroTier和香港的服务器虚拟局域网相连，并且通过Nginx反代
* Nginx配置好了SSL证书，开启了强制使用HTTPS链接

​    测试的现状：

* 在开启强制HTTPS链接的时候使用CDN加速，连接CloudReve的时候会出现Network Error，网页控制台报错重定向次数过多。
* 关闭强制HTTPS链接使用CDN加速并且通过HTTPS进行链接的时候正常。

> 参考了的可能有帮助的解决方案
>
> 1. [踩坑记录：CDN开启强制https之后返回重定向次数过多的问题](https://www.dyxmq.cn/uncategorized/踩坑记录：cdn开启强制https之后返回重定向次数过多的.html)

## 尝试了的解决办法

1. 由于CDN是先到香港的服务器，是https访问，然后香港的服务器到自己的网盘是http访问，根据上方参考的"踩坑记录"方案一，给家里的服务器的cloudreve加了一个ssl证书再次尝试代理，问题依旧。

2. 同根据“踩坑记录”，在nginx的配置文件中添加以下配置

   `proxy_set_header X-Forwarded-Proto $scheme;`

   附上解释原因：

   > 设置http头部`X-Forwarded-Proto`，这个头部的作用是用于识别协议（HTTP 或 HTTPS），主要针对内部访问重定向时的协议。因此，只要在反向代理时添加以上配置就好了
   >
   > `$scheme`是nginx的内部变量，表明当前访问的协议，当前如果是https，那么转发到后台服务的时候就是https。这样问题就解决了。

   **但是问题依旧**

   之后认为问题不出在香港服务器到家中服务器，寻找其他的解决方案。

## 在非Cloudflare的CDN上的解决方案

​    在查询和强制HTTPS有关词条的时候查询到这是CDN云加速很容易遇到的一个问题，解决方案主要有三种。

1. 设置CDN的回源端口为443端口，让CDN回源的时候以HTTPS请求源站，这样就不会触发源站的强制跳转的逻辑了。
2. 在CDN的控制台中设置回源设置为“跟随”（一般会有三个选项，分别是“回源”，“HTTP”和“HTTPS”。）
3. 放弃强制跳转HTTPS，在Nginx关闭强制。

## 最后在Cloudflare上的解决方案

​    由于没有找到Cloudflare上有类似CDN控制台的地方（感觉毕竟是免费的，没有正常。不过也可能是我太菜了不知道在哪里），于是上面的三种办法都不得不作罢，只能另寻其他办法。

1. 香港的服务器上关闭Nginx的强制https
2. 在cloudflare的"Rules"里面添加Page Rules，设置里面添加对应的域名，然后开启始终使用HTTPS

> 有一说一，结果是启用了免费的CDN以后速度还是比较慢，而且多线程下载也没有缓存很多文件，后期还是试试Cloudflare Partner或者其他的项目比较好。
