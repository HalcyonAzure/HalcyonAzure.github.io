---
layout: post
title: "CloudReve个人网盘引导"
date: 2021-04-06 10:00:00
categories: 安装引导
tags: Linux
---

## 预先准备

1. 安装好宝塔面板，并且预先安装好LNMP环境
2. Aria2离线下载配置
3. 在[FreeSSL](https://freessl.cn)上获取SSL证书和密钥

## CloudReve部署

### 安装CloudReve

1. 前往[官方库](https://github.com/cloudreve/Cloudreve/releases)下载最新版的对应系统的可执行文件

2. 在BT面板内添加网站CloudReve，并且设置对应的域名和根目录（下图为示例）

   ![BT面板创建新网站](https://lsky.halc.top/gIy7SN.png)

3. 将可执行文件上传到在宝塔面板设置的根目录中，并`cd`到当前目录

4. 运行CloudReve，并记录初始的账号密码

   ```shell
   chmod +x ./cloudreve
   ./cloudreve
   ```

5. 登入`http://ip:5212`，在控制面板中修改默认的管理员账号和密码

### 修改数据库为MySql

> 自带的数据库是SQLite，这里需要修改为MySql

1. 在宝塔面板创建一个MySql数据库

2. 在运行一次CloudReve后，根目录会有一个`conf.ini`的文件，根据自己情况加入以下配置文件

   ```shell
   ; 数据库相关，如果你只想使用内置的 SQLite数据库，这一部分直接删去即可
   [Database]
   ; 数据库类型，目前支持 sqlite | mysql
   Type = mysql
   ; MySQL 端口
   Port = 3306
   ; 用户名
   User = root
   ; 密码
   Password = root
   ; 数据库地址
   Host = 127.0.0.1
   ; 数据库名称
   Name = v3
   ; 数据表前缀
   TablePrefix = cd_
   ; SQLite 数据库文件路径
   DBFile = cloudreve.db
   ```

### 添加进程守护

> 这里使用Ubuntu自带的systemd进行进程守护

1. 编辑配置文件

   `vim /usr/lib/systemd/system/cloudreve.service`

2. 将下文的`PATH_TO_CLOUDREVE`更改为宝塔面板中设置的根目录

   ```shell
   [Unit]
   Description=Cloudreve
   Documentation=https://docs.cloudreve.org
   After=network.target
   After=mysqld.service
   Wants=network.target
   
   [Service]
   WorkingDirectory=/PATH_TO_CLOUDREVE
   ExecStart=/PATH_TO_CLOUDREVE/cloudreve
   Restart=on-abnormal
   RestartSec=5s
   KillMode=mixed
   
   StandardOutput=null
   StandardError=syslog
   
   [Install]
   WantedBy=multi-user.target
   ```

3. 载入进程守护并运行

   ```shell
   systemctl daemon-reload
   systemctl start cloudreve
   systemctl enable cloudreve
   ```

### 设置Nginx反代

1. 在宝塔面板的站点设置中，添加反向代理，配置按下图类比设置(主要还是第二步)

   ![BT设置反向代理](https://lsky.halc.top/supU6G.png)

2. 点击配置文件，将原本的`location /{}`的内容替换如下内容

   ```bash
   location / {
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header Host $http_host;
       proxy_redirect off;
       proxy_pass http://127.0.0.1:5212;
   
       ## 如果您要使用本地存储策略，请将下一行注释符删除，并更改大小为理论最大文件尺寸
       ## client_max_body_size 20000m;
   }
   ```

3. 保存配置文件，通过宝塔中设置的网站域名即可直接访问网盘地址

### 配置SSL证书

1. 在FreeSSL获取证书以后，在`KeyManager`中导出证书和私钥，分别为`.crt`和`.key`文件
2. 在站点设置中找到SSL，使用`其他证书`，然后通过编辑器打开`crt`证书文件和`key`文件，分别将其中的内容复制到`密钥(KEY)`和`证书(PEM格式)`中
3. 保存并开启强制HTTPS，即可通过SSL访问云盘并且进行配置了。

参考网站：

1. [Cloudreve对接onedrive搭建属于自己的网盘系统 (lanhui.co)](https://blog.lanhui.co/1623.html)
2. [CloudReve官方文档](https://docs.cloudreve.org/)
