---
layout: article
title: "使用Aegis二步验证"
tag: Linux
---

## 前言

​    偶然发现了`Aegis`这类手机上的二步验证软件，并且找到了添加`Steam`令牌的方法。由于`Aegis`并不自带互联网连接（在issues#630中有提及），所以需要自己想办法备份。自己刚好在研究`WebDav`的一些功能拓展，也找到了一个安卓上的拥有`WebDav`备份功能的软件`AutoSync`，于是结合一下就有了这篇博客。

## 有关链接

1. [Aegis: A free, secure and open source app for Android to manage your 2-step verification tokens](https://github.com/beemdevelopment/Aegis)
2. [如何通过第三方验证软件使用Steam令牌](https://www.coolapk.com/feed/12046283?shareKey=OTU2OWIxY2QwMTJiNjBjNDhlYjM~&shareUid=2384839&shareFrom=com.coolapk.market_11.2.3)
3. [AutoSync 官网地址](https://metactrl.com/)

## 获取Steam口令

* 有ROOT的情况：
  1. 直接使用`Aegis`自带的导入`Steam`数据即可
* 无ROOT的情况：
  1. 首先获取系统较高的权限
  2. 安装MT管理器或者其他高级文件管理器
  3. 找到`/data/data/com.valvesoftware.android.steam.community/files`目录
  4. 以文本的形式打开该目录下的`Steamguard-xxxxxxx`文件
  5. 找到`otpauth`后的内容，并找到最近的`secert`字样，复制`&issuer`前面的内容（不包括`&issuer`）
  6. 打开`Aegis`，添加新的配置，`Digits`设置`5`，时间设置`30s`，`secret`填入复制内容即可

## 文件备份

> 博客使用的AutoSync下载地址来源于[异星软件空间](https://www.yxssp.com/)，仅供学习使用，请在24小时内删除。继续使用请购入正版。

1. 在`CloudReve`中创建一个`WebDav`连接（`CloudReve`的搭建教程在前期博客中有写）
2. 根据`AutoSync`中的引导进行文件配置，并且设置好定时更新的时间。

## 后续

​    这篇博客本身没什么技术含量，主要是节约寻找对应需求软件的时间，安卓上轻量并且好用的WebDav自动同步软件并不多，此贴仅做记录，方便后续参考。
