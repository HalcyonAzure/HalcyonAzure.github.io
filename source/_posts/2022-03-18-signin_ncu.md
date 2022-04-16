---
layout: article
title: "通过Python提交ncu每日健康信息"
date: 2022-03-18 10:00:00
categories: 小技巧
tags: python
---

## 声明

1. 该方法目前稳定性尚不确定，`Token`有概率会不定时失效，如果使用后果自负
2. 该方法仅作`Python`学习使用，了解原理后使用后果自负
3. 疫情期间请以实际情况打卡汇报，切勿身体有状况而依旧以无状况打卡。

## 参考文章

1. [简单三步，用 Python 发邮件 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/24180606?theme=dark)
2. [github action获取仓库secrets](https://nekokiku.cn/2020/12/22/2020-12-22-Github-Action%E4%B8%ADpython%E8%8E%B7%E5%8F%96%E4%BB%93%E5%BA%93%E7%9A%84secrets/)

## 实现的效果

​通过Github Actions，在每天通过`cron`设定的时间实现企业微信打卡

## 运行环境

Github Actions

## 需要准备的东西

QQ号以及QQ的SMTP密码

## 获取Token

1. 在打卡界面中"复制链接"，并在电脑上打开

   ![企业微信](https://lsky.halc.top/DH7lVf.png)

2. 电脑浏览器打开链接，按F12，此时可能是电子ID，不用管，在右上角找到`Network`，并打开。

   (如果提示要按Ctrl+R，按就行)

   ![Network](https://lsky.halc.top/Xl1nNE.png)

3. 在`Network`下方找到`loginByToken`，并且找到右边的`Token`信息，复制保存。

   ![TokenGet](https://lsky.halc.top/IpnCQJ.png)

## 获取QQ邮箱的SMTP密码

[百度搜索：获取QQ邮箱的SMTP密码](https://www.baidu.com/s?wd=%E8%8E%B7%E5%8F%96QQ%E9%82%AE%E7%AE%B1%E7%9A%84SMTP%E5%AF%86%E7%A0%81)

## 编辑Python脚本

大致思路就是通过对应接口抓包后发包即可，更新`Token`通过接口`LoginByToken`实现，打卡通过`SignIn`接口实现。
参考脚本：[Scripts/ncu.py](https://github.com/HalcyonAzure/Scripts/blob/master/python/ncu.py)

## 运行脚本并测试

为了仓库的信息安全，所有的密码通过Github仓库下secrets来进行设置，然后参考 [github action获取仓库secrets](https://nekokiku.cn/2020/12/22/2020-12-22-Github-Action%E4%B8%ADpython%E8%8E%B7%E5%8F%96%E4%BB%93%E5%BA%93%E7%9A%84secrets/) 中提及的方法修改设置即可。

## 备注

***每个人都有义务在疫情大环境下对自己的真实信息负责***
