---
layout: post
title: "Docker传递操作进容器内的不同方式"
date: 2021-08-02 10:00:00
categories: 小技巧
tags: Docker
---

## 进入容器

1. 使用`docker exec -it`命令进入容器（推荐）

   假设操作的容器ID为`icontainer`，如果想要进入`icontainer`执行指令，只需要输入以下指令：

   ```shell
   docker exec -it icontainer /bin/bash
   ```

   如果需要退出容器，输入`exit`或者`Ctrl+C`即可

2. 使用`docker attach`命令进入

   同样以`icontainer`举例，则需要输入以下指令来进入容器终端

   ```shell
   docker attach icontainer
   ```

   ***但这样有缺点，即退出终端的同时，该容器也会同样退出，所以推荐使用`exec`的方法进入容器***

## 文件传递

​    先直接上指令，以容器`icontainer`为例，我需要将该容器下的`/opt/demo/demo.zip`拷贝到宿主机的`/opt/Backup/`下，那么我的指令如下：

```shell
docker cp icontainer:/opt/demo/demo.zip /opt/Backup/
```

​    同理，如果我需要将`Backup`下的`demo.zip`传递到容器内，我也可以使用如下指令传输到容器的`recover`文件夹内：

```shell
docker cp /opt/Backup/demo.zip icontainer:/opt/recover/
```

>备注：文件传递和容器是否启动无关，都会直接对文件进行修改
