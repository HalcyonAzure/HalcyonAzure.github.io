---
layout: post
title: qbit与jellyfin搭建自动追番引导
categories: 安装引导
tags:
  - qbittorrent
  - jellyfin
  - docker
date: 2022-05-07 10:00:12
---

## 环境

* Docker Engine: `20.10.15`
* Ubuntu: `20.04.4 LTS`
* X86平台

## 部署教程

部署使用的是老电脑上的`Ubuntu 20.04.4 LTS`，为了便于备份配置以及轻量上手，采用了`Docker-Compose`的一件式部署方式，该方案主要倾向解决追番问题，目前基本解决刮削问题。

### Docker安装

请在百度等搜索引擎直接搜索对应自己平台的"Docker 安装 教程"

### Docker-Compose部署

推荐的`qBittorrent`+`Jellyfin`部署配置文件如下

```yaml
version: '3'
services:
  jellyfin:
    image: nyanmisaka/jellyfin:latest
    restart: unless-stopped
    container_name: jellyfin
    volumes:
      - $PWD/conf/jellyfin:/config  # 对应Jellyfin的配置文件
      - $PWD/cache:/cache  # 对应Jellyfin的缓存文件
      - $PWD/downloads/media:/media  # 对应Jellyfin的媒体文件夹
    ports:
      - "8096:8096"
    environment:
      - TZ=Asia/Shanghai
      - UID=1000
      - GID=1000
    devices:
      - /dev/dri:/dev/dri  # 如果要使用硬解配置

  qbittorrent:
    image: johngong/qbittorrent:latest
    restart: unless-stopped
    hostname: qbittorrent
    container_name: qbittorrent
    volumes:
      - $PWD/conf/qbit:/config
      - $PWD/downloads:/Downloads
    network_mode: "host"
    environment:
      - UID=0
      - GID=0
      - TRACKERSAUTO=YES
      - WEBUIPORT=8995  # 网页端口
      - TRACKERS_LIST_URL=https://cdn.jsdelivr.net/gh/ngosang/trackerslist@master/trackers_all.txt  # 自动更新种子文件
      - UMASK=022
```

> 如果出现了qBittorrent配置有可能随着更新有变化，如果使用过程中出现问题，或需要自己额外配置，具体参考[johngong/qbittorrent](https://hub.docker.com/r/johngong/qbittorrent)内的介绍进行修改即可。

### 配置自动改名工具

下载 [EpisodeReName.zip](https://github.com/Nriver/Episode-ReName/files/8644661/EpisodeReName.zip) 并且解压在`qbittorrent`挂载的`Downloads`目录下，用于下文中设置自动改名

## 使用效果

### RSS订阅

1. 在诸如[蜜柑计划](https://mikanani.me/?ref=www.myiys.com)的网站，找到自己想要看的番剧或电视剧对应的`RSS`链接

2. 在`qbittorrent`当中添加RSS规则，示例如下

   ![RSS订阅](https://lsky.halc.top/uPhEeN.png)

3. 添加完毕RSS规则以后，则需要设置下载路径。由于`Jellyfin`刮削为识别文件夹名字进行刮削，因此这里的命名必须要符合规范来提高成功率

   ![下载路径设置](https://lsky.halc.top/9FKNvM.png)
   注意文件夹命名要为"番剧名/S+季度数"即可

4. 在`qbittorrent`设置内开启自动下载，后续只要识别到了RSS更新，就能自动下载到目标文件夹下

### 自动修改剧集名

自动修改剧集名字使用的为[Episode-ReName](https://github.com/Nriver/Episode-ReName)工具

1. 下载并将`Episode-ReName`放于`Docker`挂载后的`downloads`目录下

2. 配置下载完毕自动运行`EpisodeRename`来对番剧重命名

   ![自动重命名](https://lsky.halc.top/D99DtN.png)

    配置参数如下

    ```sh
    /Downloads/EpisodeReName "%D/%N" 10 
    # 10指下载完毕10s后执行
    # "%D/%N"指对下载完毕后单文件执行
    ```

3. 由于重命名后的文件无法直接继续做种，因此在`qbittorrent`内同样要设置自动取消做种上传

    ![取消做种](https://lsky.halc.top/OGxcUV.png)

    **秉承BT分享的精神，或者使用PT站的朋友可以学习如何设置硬链接等方式对文件实现共享，本文不做解释**

### Jellyfin元数据插件

元数据刮削主要用的是`TheMovieDb`, `AniDB`, `AniSearch`和`AniList`这几个插件，不过依旧存在抓取的时候抓到英文介绍为多的问题，不过暂且算是能使用，海报和宣传图也基本上都有，日常使用没有很大问题
