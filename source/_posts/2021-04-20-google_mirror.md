---
layout: post
title: "Google镜像站创建引导"
date: 2021-04-20 10:00:00
categories: 安装引导
tags: Nginx
---

步骤如下:

1. 在宝塔面板中创建Google的Nginx反代`www.google.com.hk`

2. 配置SSL证书并保存，启用HTTPS

3. 配置upstream设置

   * 通过如下方式获取google的不同ip

     `dig www.google.com @8.8.8.8 +short`

   * 将类似如下配置文件配置好

     ```nginx
     upstream www.google.com.hk {
          ip_hash;
          server 108.177.125.199:443;
          server 64.233.189.199:443;
          server 74.125.23.199:443;
          server 172.217.24.35:443;
          }
     
     server
     {...}
     ```

4. 在server中配置防爬虫和禁止IP访问

   ```nginx
   server
   {
   
       ...
   
       # 防止网络爬虫
       #forbid spider
       if ($http_user_agent ~* "qihoobot|Baiduspider|Googlebot|Googlebot-Mobile|Googlebot-Image|Mediapartners-Google|Adsbot-Google|Feedfetcher-Google|Yahoo! Slurp|Yahoo! Slurp China|YoudaoBot|Sosospider|Sogou spider|Sogou web spider|MSNBot|ia_archiver|Tomato Bot") 
       { 
           return 403; 
       }
   
       # 禁止用其他域名或直接用IP访问，只允许指定的域名访问
       #forbid illegal domain
       if ( $host != "yourdomain.com" ) {
           return 403; 
       }
        
       ...
       
   }
   ```

5. 检查并重启配置文件

   `nginx -t && nginx -s reload`

6. 在宝塔防火墙中关闭'GET'过滤，否则会导致搜索某些关键词的时候被误判封锁IP

参考文章:

1. [(*´∇｀*) 被你发现啦~ 搭建google镜像网站(适用最新版nginx)Module for Google Mirror – 深海 (oyi.me)](https://blog.oyi.me/619)
