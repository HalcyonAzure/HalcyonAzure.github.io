---
layout: article
title: "安装Docker"
categories: 安装引导
tags:  Docker
---

参考资料:
1.[Docker-从入门到实践](https://yeasy.gitbook.io/docker_practice/install/ubuntu)

> 在挂载网易云音乐灰色代理的时候终于还是发现了screen后台运行的坏处，经常会出现不小心重启以后忘记开启服务的情况，由于之前一直听说过docker容器，并且灰色代理有现成的docker容器可以使用，在简单查询和操作了一下以后记录一下docker启动网易云音乐并且进行网易云音乐代理的实战

## Docker部署和安装

1. (可选) 通过一键脚本进行安装

   ```bash
   curl -fsSL get.docker.com -o get-docker.sh
   sudo sh get-docker.sh --mirror Aliyun
   ```

   如果要安装测试版的Docker，则用以下脚本

   ```bash
   curl -fsSL test.docker.com -o get-docker.sh
   sudo sh get-docker.sh --mirror AzureChinaCloud
   ```

2. 使用`apt`进行安装

   ```bash
   sudo apt-get update
   
   sudo apt-get install \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg \
       lsb-release
   ```

3. 替换国内软件源

   ```bash
   curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   
   echo \
     "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

4. 安装Docker

   ```bash
   sudo apt update
   sudo apt install docker-ce docker-ce-cli containerd.io
   ```

5. 启动Docker

   ```bash
   sudo systemctl enable docker
   sudo systemctl start docker
   ```

6. 检测是否已经设置镜像

   > 请首先执行以下命令，查看是否在 `docker.service` 文件中配置过镜像地址。
   >
   > ```bash
   > $ systemctl cat docker | grep '\-\-registry\-mirror'
   > ```
   >
   > 如果该命令有输出，那么请执行 `$ systemctl cat docker` 查看 `ExecStart=` 出现的位置，修改对应的文件内容去掉 `--registry-mirror` 参数及其值，并按接下来的步骤进行配置。

7. 设置镜像

   创建并编辑`/etc/docker/daemon.json`

   写入以下内容

   ```shell
   {
     "registry-mirrors": [
       "https://hub-mirror.c.163.com",
       "https://mirror.baidubce.com"
     ]
   }
   ```

8. 重启服务

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart docker
   ```

9. 检测是否正常

   `docker run --rm hello-world`

   通过检查返回信息检查是否成功安装并且部署Docker环境
