---
layout: article
title: "过滤Clash中Steam登入域名[无效]"
tag: Windows
---

> 测试后发现Steam会有几个固定的纯IP来次测试链接位置，只过滤域名并没有什么用

## 前言

> 字太多可不看。

在开启了Clash之后，经常会每次登入Steam都出现无法保存密码，需要重新输入密码的情况。出现这种情况的原因是因为Steam根据`store.steampowered.com`确定自己的位置，在开了加速器/Clash之后，由于加速的原因经常出现大范围的IP变动，所以导致Steam需要重新输入密码来验证。解决问题的办法也很简单，只需要在Clash中添加规则让对应域名不走加速即可。

添加规则可以在自己手动订阅配置文件后一次一次添加，也可以通过`Clash For Windows`下的`parsers`配置修改来让每次配置文件更新的时候进行一个预处理，按自己的需求进行添加，具体操作可以参考：[配置文件预处理 Clash for Windows](https://docs.cfw.lbyczf.com/contents/parser.html#版本要求)

在`Clash For Windows`下的`Settings`当中的`System Proxy`里面有一个`Bypass Domain/IPNet`，但是我单纯设置成类似如下配置文件的时候发现无法生效，加上`Parsers`很简单就成功了，遂没有仔细研究，作罢。以下为`Parsers`的配置

## 添加预处理规则

这篇博客主要只针对Steam登入的问题进行解决，不过同样可以举一反三适用于其他类似的需要预处理配置文件的场景。

### 使用URL订阅

1. 打开`Clash For Windows`，打开`Settings`，找到`Profiles`的选项，其中有一条`Parsers`，右侧可以点击`Edit`进行编辑。

2. 在`Edit`中参考如下配置进行编辑  ***注意缩进***

   ```yaml
   parsers:
     - url: #这里填入需要预处理的配置文件的URL订阅链接。
       yaml:
         prepend-rules:
           - DOMAIN-SUFFIX,store.steampowered.com,🎯 全球直连
   ```

3. 重新启动Clash即可

### 使用本地配置文件

1. 只需要在配置文件的`rules`下添加如下配置即可：

   ```yaml
   DOMAIN-SUFFIX,store.steampowered.com,🎯 全球直连
   ```

2. 重启Clash
