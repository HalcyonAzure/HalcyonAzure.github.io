---
layout: post
title: Github的PAT口令的密码记录和保存方案
categories: 小技巧
tags: Github
abbrlink: a126ef4d
date: 2022-03-15 10:00:00
updated: 2022-03-15 21:13:00
---

## 参考链接

* [Where to store my Git personal access token?](https://stackoverflow.com/a/51505417)
* [GitCreadentitalManager](https://github.com/GitCredentialManager/git-credential-manager/blob/main/docs/credstores.md)
* [GitCredential](https://git-scm.com/docs/gitcredentials)

## 简单方案

最简单的方案是讲自己的配置文件用明文保存，在[文档](https://git-scm.com/docs/gitcredentials)中查询可知道指令如下

```shell
git config --global credential.helper store
```

在设置`credential.helper`为全局`store`之后，下一次的验证会出现提示并保存，之后则会使用存在`~/.git-credentials`的明文帐号密码进行登入

## 加密方案

为了更好的管理Github的Token，需要一个Git凭证助手来帮我们记忆用户名和对应的PAT，以下为`Git-Credential-Manager-Core`引导

### 安装

安装[Lateset Release](https://github.com/microsoft/Git-Credential-Manager-Core/releases/)的GCM，并初始化设置

   ```bash
   sudo dpkg -i <path-to-package>
   git-credential-manager-core configure
   ```

### 配置

在Linux上使用GCM需要额外设置`credential.credentialStore`，其中包含的设置方法如下：

#### 通过[Secret Service API](https://specifications.freedesktop.org/secret-service/latest/)来存储
  
***该方法需要系统有GUI显示功能***

```bash
export GCM_CREDENTIAL_STORE=secretservice
# or
git config --global credential.credentialStore secretservice
```

这个办法通过`libsecret`库来和`Secret Service`进行交互，所有的凭证都存储在“collections”当中。如果要查看的话，可以通过`secret-tool`或`seahorse`来进行查看。注：在请求用户帐号信息的时候会通过GUI来进行交互。

#### 通过Git自带的凭证缓存机制来存储

```bash
export GCM_CREDENTIAL_STORE=cache
# or
git config --global credential.credentialStore cache
```

这种方法保存的密码不会以可长期读取的文件形式存在硬盘上，如果是需要链接一些临时性的服务可以用这个方法。默认来说`git credential-cache`会储凭证900s，可以通过如下指令修改：

```bash
export GCM_CREDENTIAL_CACHE_OPTIONS="--timeout 300"
# or
git config --global credential.cacheOptions "--timeout 300"
```

#### 通过纯文本的形式进行保存
  
***这办法不安全***

```bash
export GCM_CREDENTIAL_STORE=plaintext
# or
git config --global credential.credentialStore plaintext
```

这种办法保存的密码默认会存在`~/.gcm/store`目录下，目录可通过`GCM_PLAINTEXT_STORE_PATH`环境变量来进行修改，如果文件不存在则会被创建新创建的文件权限为`700`.

#### 通过GPG/pass进行存储

***这种方法需要有一对GPG密钥***

```bash
export GCM_CREDENTIAL_STORE=gpg
# or
git config --global credential.credentialStore gpg
```

这种办法主要使用了[pass](https://www.passwordstore.org/)工具，默认情况下文件会保存在`~/.password-store`文件下，该目录可以通`PASSWORD_STORE_DIR`来进行修改。在使用这种办法进行凭证管理之前，首先需要通过一对GPG密钥对`pass`进行初始化操作。

```bash
pass init <gpg-id>
```

这里的\<gpg-id\>指的是当前使用gpg密钥对的用户的系统id。通过以下指令可以创建一个自己的gpg密钥对：

```bash
gpg --gen-key
# and follow prompts
```
