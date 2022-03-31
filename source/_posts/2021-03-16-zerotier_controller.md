---
layout: article
title: "搭建ZeroTier Controller管理网络引导"
date: 2021-03-16
categories: 安装引导
tags: ZeroTier
---

> **本来的理解**: 在使用ZeroTier的时候经常会出现穿透失败，或者穿透延迟过大但是中转服务器不好用的情况，之前有参考过网上的教程来通过一台国内的VPS搭建自己的MOON节点来达到加速的目的，但是最后的效果不尽人意，而且还存在安卓端添加mood节点并不轻松的问题，所以在这里采取直接通过[key-networks/ztncui: ZeroTier network controller UI](https://github.com/key-networks/ztncui)搭建自己的ZeroTier根服务器

​    最近在使用`zerotier-cli listpeers`指令的时候发现设置的控制器是一个`LEAF`而不是本来预期的`PLANT`，在查阅了一部分资料之后发现如果想要加速网络的话目前比较好的方便还是`MOON`服务器进行中转，详情参考另外一篇`ZeroTier下Moon服务器的搭建`。

## 安装准备

1. 准备好一台在国内，至少开放端口3443端口的服务器（暂未测试对其他端口是否有需求）

2. 在服务器内安装ZeroTier，以下为一键安装脚本

   `curl -s https://install.zerotier.com | sudo bash`

   如果服务器有安装GPG，则需要多几个步骤

   ```bash
   curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && \
   if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
   ```

## 部署ztncui

### RPM installation on EL7

1. `sudo yum install https://download.key-networks.com/el7/ztncui/1/ztncui-release-1-1.noarch.rpm -y`

2. `sudo yum install ztncui -y`
3. (可选择)：添加服务器自己的TLS/SSL证书，或者添加服务器自认证的证书 - **后文有教程**

4. 开放服务器的3443端口(已开放可忽略)

5. `sudo sh -c "echo 'HTTPS_PORT=3443' > /opt/key-networks/ztncui/.env"`

6. `sudo sh -c "echo 'NODE_ENV=production' >> /opt/key-networks/ztncui/.env"`

7. `sudo systemctl restart ztncui`

8. 通过HTTPS来在服务器的3443端口访问控制界面，比如

   `e.g. https://my.network.controller:3443`

9. 通过默认的账号`admin`和密码`password`.

### DEB installation on Debian/Ubuntu

1. `curl -O https://s3-us-west-1.amazonaws.com/key-networks/deb/ztncui/1/x86_64/ztncui_0.7.1_amd64.deb`

2. `sudo apt-get install ./ztncui_0.7.1_amd64.deb`
3. (可选择)：添加服务器自己的TLS/SSL证书，或者添加服务器自认证的证书 - **后文有教程**

4. 开放服务器的3443端口(已开放可忽略)

5. `sudo sh -c "echo 'HTTPS_PORT=3443' > /opt/key-networks/ztncui/.env"`

6. `sudo sh -c "echo 'NODE_ENV=production' >> /opt/key-networks/ztncui/.env"`

7. `sudo systemctl restart ztncui`

8. 通过HTTPS来在服务器的3443端口访问控制界面，比如

   `e.g. https://my.network.controller:3443`

9. 通过默认的账号`admin`和密码`password`.

## 笔记

1. 如果要添加额外的监听端口，只需要在`/opt/key-network/ztncui`下面添加一个`.env`文件，其中附带一行

   `HTTPS_PORT=3443`

   或者任意一个大于1024的端口即可。

2. 如果存在`.env`文件来指向特定的一个端口，那么ztncui将会在所有的端口监听网络，如果希望限制一个特定的IP进行监听的话，只需要在`.env`文件中再添加一行

   `HTTPS_HOST=12.34.56.78`

   来设置自己制定的IP或者域名即可。

## 添加Self-signed Certificate

> 这种方法添加的证书会存在浏览器警告的问题，不过由于是自己使用，平时也不会一直盯着控制界面，所以影响应该不会很大，如果有共用或者对安全有需求建议自行添加

以下为无脑脚本

```bash
sudo -i
cd /opt/key-networks/ztncui/etc/tls
rm -f privkey.pem fullchain.pem
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout privkey.pem -out fullchain.pem
chown ztncui.ztncui *.pem
chmod 600 privkey.pem
```

## 配置ztnui

由于ztnui是自己搭建的一个ZeroTier服务器，所以并没有预先设置好的DHCP分配，需要自己设置分配范围。如果需要添加一个新的网络，在使用账号密码登入以后，点击`Add network`就可以添加一个自己的虚拟局域网络

1. 点击Add network

2. 设置好network的名字并create

3. 如果需要设置"隐私"与否，在Private中设置即可，这里稍作翻译即可看懂，所以不多解释

4. 点击如下图所示的Easy Setup来快速完成一个IPv4的DHCP分配

   ![ESETUP](/2021/03/images/ztnui_1.png "DHCP分配")

5. 如下图所示填入对应信息

   ![IPPOOL](/2021/03/images/ztnui_2.png "IP_POOL")

   以下为一个例子:

   ```bash
   网关:192.168.192.0/24
   起始IP:192.168.192.1
   终止IP:192.168.192.254
   ```

6. 然后点submit即可快速创建，也可以通过generate network address的方式自动随机填入。
7. 如果需要设置NAT路由，则只需要在Routes下进行配置和添加即可。
