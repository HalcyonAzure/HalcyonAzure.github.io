---
layout: article
title: "Docker简单入门"
tag: Docker
---

参考链接:

1. [CSDN-Ubuntu 18.04 DOCKER的安装](https://blog.csdn.net/weixin_44070676/article/details/106942848)
2. [停止、删除所有的docker容器和镜像](https://colobu.com/2018/05/15/Stop-and-remove-all-docker-containers-and-images)
3. [Docker官网文档](https://docs.docker.com/)

## Docker用户组配置

设置用户组`docker`，让用户不需要sudo也可以使用docker相关命令

   ```bash
   sudo groupadd docker
   sudo gpasswd -a $USER docker
   newgrp docker
   docker ps
   ```

* 查看当前所有在运行的Docker容器

  `docker ps -a`

* 在库内搜索需要的docker容器运行

  `docker search [name]`

* 获取需要的容器

  `docker pull [name]`

* 停止所有的容器

  `docker stop $(docker ps -aq)`

* 删除所有的容器

  `docker rm $(docker ps -aq)`

  * 删除所有目前没有在运行的容器

    `docker container prune`

* 删除所有的镜像

  `docker rmi $(docker images -q)`

  * 删除所有未被使用的镜像

    `docker image prune`

* 删除所有未被引用的容器，镜像和各种cache

  `docker system prune`
  
* 重命名容器

  ```shell
  docker rename [Docker的Name] [修改后的Name]
  ```

## 运行Docker的指令

> Docker在运行的过程中有许多额外设置，其中包括不同的网络结构，不同的运行模式，交互方法等，目前在这里只记录一些简单用得上的，后续如果还有比较常用的指令再进行补充添加。

### 例子

`docker run -d --restart=always --network host --name CloudMusic nondanee/unblockneteasemusic`

1. `docker run`

   运行docker容器

2. `-d`

   以后台模式运行

3. `--restart-always`

   每次docker如果重启了的话也总是自动运行

4. `--network host`

   以`host`网络模式运行docker容器，而不是以默认的NAT分布

5. `--name CloudMusic`

   给这个容器命名为CloudMusic

* 进入容器
  1. `docker attach <ID>`
  2. `docker -it <ID> /bin/bash`或者`docker -it <ID> /bin/sh`

## Docker设置开机自启动

1. 通过systemctl设置docker开机自启动

   `systemctl enable docker.service`

2. docker容器使用`--restart=always`参数启动

   * 如果已经启动了可以通过`docker update --restart=always <ID>`添加参数

3. 重启系统以后通过`docker ps -a`可以看到服务已经在正常运行了

## Docker容器参数配置

1. 用命令修改

   ```shell
   docker container update --help
   ```

   > 使用这个指令可以在不停止容器的情况下更新部分内容，比如容器的启动方式

2. 配置文件修改

   * ***首先要停止容器，才能对容器的配置文件进行修改***
   * 配置路径为`/var/lib/docker/containers/容器ID`下的`hostconfig.json`就是配置文件
