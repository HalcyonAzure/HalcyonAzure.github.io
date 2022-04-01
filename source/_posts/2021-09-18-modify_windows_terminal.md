---
layout: article
title: "Oh My Posh美化Windows Terminal引导"
date: 2021-09-18
categories: 小技巧
tags: [Windows, PowerShell]
---
<!-- markdownlint-disable MD033-->

## 参考文章

* [[How to Install and Update PowerShell 6 - Thomas Maurer]](https://techcommunity.microsoft.com/t5/windows-powershell/how-to-install-and-update-powershell-6-one-liner/m-p/364948)
* [Windows Terminal + oh-my-posh模块美化官方教程集锦以及常见问题_想追头头の疾风的博客](https://blog.csdn.net/weixin_44490152/article/details/113854767)

## 更新PowerShell

​    更新PowerShell本身和Windows Terminal没啥直接关系，单纯做个提醒放一个一键更新指令在这里：

```powershell
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
```

这条命令的作用是安装最新版本的PowerShell，截至发博客为止可用于安装`PowerShell 7`

## Windows Terminal的安装&美化

### Windows Terminal安装

1. 打开Microsoft Store
2. 搜索`Windows Terminal`
3. 安装

## Windows Terminal的配置和使用

### Windows Terminal的使用

* 在`Win+R`中输入`wt`回车即可呼出`Windows Terminal`
* `Windows Terminal`中链接了一些Linux下可用的指令，诸如`ls`等
* 如果要在`Windows Terminal`下使用`vim`编辑器，只需要在安装了`Git`的前提下将`C:\Program Files\Git\usr\bin`设置为环境变量即可。(如果`Git`安装在其他目录下进行相对应的调整就好，设置好了以后重启一次`Windows Terminal`即可)

### Windows Terminal的个性化配置

> 如未特别说明，接下来将用`wt`作为`Windows Terminal`的简写

注：本文个性化配置包括：

* 修改`Windows Terminal`的配色

* 安装`posh-git`和`oh-my-posh`
* 安装`Nerd Font`字体
* 配置`oh-my-posh`来修改`wt`的配色和样式

不包括（以下设置在最新版的`wt`设置中已经包含）：

* 毛玻璃和背景设置
* 光标形状、大小修改等

#### 配色修改

1. 在[mbadolato/iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)下滑，找到自己喜欢的配色的截图，在截图的左上方会有该配色的代号。

2. 在[iTerm2-Color-Schemes/windowsterminal](https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/windowsterminal)上找到配色对应的json文件并复制所有的内容。

3. 在`wt`中打开设置，以下图为例：

   <img src="https://lsky.halc.top/XsycIz.png" alt="打开设置.png" style="zoom: 33%;" />

4. 打开JSON设置，以图下为例：

   <img src="https://lsky.halc.top/FGEI3J.png" alt="打开JSON文件.png" style="zoom: 25%;" />

5. 将刚刚复制的代码粘贴到有`scheme`字样的配置目录下，以下图为例：

   <img src="https://lsky.halc.top/XURWMD.png" alt="添加主题.png" style="zoom: 33%;" />

6. 保存后，回到`wt`的设置，选择平时主要使用的窗口界面（e.g.`PowerShell`）然后选择外观，然后选择自己添加的主题，以下图为例：

   <img src="https://lsky.halc.top/8SSNzA.png" alt="修改config" style="zoom: 25%;" />

#### 安装 Nerd-Fonts 字体

> 教程以`Hack NF`字体为例，如果需要使用其他字体请自行选择。

1. 在这个页面下载的`Hack.zip`：

   [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)

2. 解压`Hack.zip`，然后全选所有文件，右键点击安装

3. 在`wt`中需要的终端，按**配色修改**第6步修改字体为`Hack NF`即可。

#### 安装post-git和oh-my-posh

> 以下教程需要电脑上安装了Git才能使用

1. 使用`PowerShell`安装`post-git`和`oh-my-posh`

   指给当前用户(非Administrator)安装：

   ```powershell
   Install-Module posh-git -Scope CurrentUser
   Install-Module oh-my-posh -Scope CurrentUser
   ```

   给所有用户安装：

   ```powershell
   Install-Module posh-git -Scope AllUsers
   Install-Module oh-my-posh -Scope AllUsers
   ```

2. 列出所有可用主题

   ```powershell
   Get-PoshThemes
   ```

3. 找到自己喜欢的主题，然后使用指令预览（这里以spaceship为例）：

   ```powershell
   Set-PoshPrompt -Theme spaceship
   ```

4. 在预览结束以后，为了让主题每次启动都生效，需要创建一个脚本。

   1. 输入以下指令：

      ```shell
      cd ~
      vim $profile
      ```

   2. 按下按键i，进入插入模式，然后填入以下内容：

      ```shell
      Import-Module posh-git
      Import-Module oh-my-posh
      Set-PoshPrompt -Theme spaceship #[这里填你选的主题名字，用spaceship做示范]
      ```

   3. 键盘键入`:wq`然后回车，代表保存并退出。

5. 重新启动`wt`即可看到自己个性化配置的`Windows Terminal`界面了。
