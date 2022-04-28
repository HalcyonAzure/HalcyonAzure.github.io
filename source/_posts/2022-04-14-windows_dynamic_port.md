---
layout: post
title: 解决Windows未使用端口被占用问题
categories: 小技巧
tags: Windows
abbrlink: 22453a61
date: 2022-04-14 16:00:00
updated: 2022-04-28 12:19:00
---

## 参考文章

1. [Hortonworks Docker Sandbox environment cannot start](https://stackoverflow.com/questions/52212012/hortonworks-docker-sandbox-environment-cannot-start/)
2. [default-dynamic-port-range-tcpip-chang](https://docs.microsoft.com/en-us/troubleshoot/windows-server/networking/default-dynamic-port-range-tcpip-chang)

## 问题产生

在无脑跟着网上教材开启Windows的`SandBox`的时候开启了Hyper-V的功能，结果尝试在`6800`端口运行和往常一样的`Aria2`的`Docker`容器的时候出现了端口报错的情况，通过`netstat`排查也没发现`6800`端口被占用了，后面发现应该是Windows的动态端口在开了`Hyper-V`之后被修改了

通过以下指令可以分别查看`ipv4/ipv6`的`tcp/udp`起始端口

```ps
netsh int ipv4 show dynamicport tcp
netsh int ipv4 show dynamicport udp
netsh int ipv6 show dynamicport tcp
netsh int ipv6 show dynamicport udp
```

在我的情况下，起始端口从原本默认的`49152`被修改成了从`1024`开始，因此`6800`端口无法使用

## 问题解决

在参考问题中找到了对应的解决方案

如果需要继续使用`windows Virtual platform form windows feature`（不确定这里是不是指Hyper-V，所以不翻译了）则

1. 关闭Windows服务上对应的功能，关闭后系统会请求重启
2. 通过以下指令修改动态起始端口 ~~(`49152`是Windows默认设置)~~ 在使用`adb`连`WSA`的调试时，发现默认端口为`58526`，所以还是用`100000`把

   ```ps
    netsh int ipv4 set dynamicport tcp start=100000 num=1000
    netsh int ipv4 set dynamicport udp start=100000 num=1000
    netsh int ipv6 set dynamicport tcp start=100000 num=1000
    netsh int ipv6 set dynamicport udp start=100000 num=1000
    ```

3. 重新启用对应的功能

如果没有Hyper-V使用需求的情况下，可以尝试直接关闭Hyper-V，然后检查起始端口是否恢复，如果没有恢复的再通过上面的指令手动重新设置起始端口即可
