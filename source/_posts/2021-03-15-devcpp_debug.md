---
layout: post
title: "Devc++调试相关选项配置"
date: 2021-03-15 10:00:00
categories: 小技巧
tags: Devc++
---

> 由于蓝桥杯比赛需要使用Devc++作为IDE工具，平时用习惯了vscode的snap和其他功能以后觉得如果不提前适应一下Devc++的编译环境的话在比赛的时候会吃很大的亏，于是决定之后的学习都用Devc++进行，在此记录一下Devc++启用调试之前需要的一些基本设置

## 启用调试信息(选做)

> 貌似在按F5准备进行调试的时候，即使自己没有进行以下设置，Devc++依旧会询问并且可以直接打开进行设置，这里只做一个提前设置的记录，并非必须

1. 首先，打开devc++之后，找到上方的Tools(工具)，如下图所示，打开其中的Compiler options(编译选项)

   ![工具](https://lsky.halc.top/khFnOI.png)

2. 然后按下图开启调试信息（设置为yes）

   ![调试信息](https://lsky.halc.top/Dy3AFE.png)

## 显示鼠标所指变量

1. 再次打开Tools，并且打开Enviroment options

2. 启用下图黄线部分的选项，开启显示指针所指变量的值

   ![指针调试](https://lsky.halc.top/lAqdhj.png)
