---
layout: article
title: "Windows字体切换的两种方法"
date: 2021-10-03 10:00:00
categories: 小技巧
tags: Windows
---

## 参考链接

1. [Tatsu-syo/noMeiryoUI](https://github.com/Tatsu-syo/noMeiryoUI)
2. [如何更换win10系统的字体](https://www.zhihu.com/question/263863102/answer/1999360871)

## 方法一

### 通过`noMeiryoUI`进行修改（推荐）

1. 在网站上找到自己喜欢的字体，通常为`ttf`、`otf`或`fnt`等文件。
2. 在`noMeiryoUI`的repo中下载该工具：[Tatsu-syo/noMeiryoUI](https://github.com/Tatsu-syo/noMeiryoUI/releases)
3. 解压后启动其中的`noMeiryoUI.exe`程序
4. 选择自己想要的字体并更改，应用的时候可能会较为卡顿，耐心等待生效即可。

## 方法二

### 通过命令行替换Windows官方字体达到应用自己字体的效果

***该方法存在一定风险，在替换Windows原本字体之前，请务必备份***

1. 下载自己想要用于替换的日用字体，并根据类型分别命名为`msyh.ttc`、`msyhbd.ttc`和`msyhl.ttc`

2. 在C盘根目录新建文件夹`TempFonts`用于临时存放需要替换的字体

3. 打开Windows的设置，找到"更新与安全"->"恢复"->"高级启动"，在高级启动之后，选择"高级选项"，选择"命令提示符"，选择自己的帐号登入

4. 输入以下指令，将C盘下`TempFonts`文件夹内的字体替换为系统默认字体。

   ```powershell
   xcopy C:\TempFonts\* C:\Windows\Fonts\
   ```

   回车后按下A来全部覆盖替换（***一定要备份好之前的系统文件再执行这一步***）

5. 输入`exit`回车后进入Windows系统，即可看到自己的字体应用生效，同理，如果想要将字体恢复，只需要用备份的字体文件进行覆盖操作即可。
