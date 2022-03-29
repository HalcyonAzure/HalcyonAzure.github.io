---
layout: article
title: "Scoop安装手册"
tag: Windows
---

## 参考文章

1. [「一行代码」搞定软件安装卸载，用 Scoop 管理你的 Windows 软件](https://sspai.com/post/52496)
2. [Scoop - 最好用的 Windows 包管理器 - P3TERX ZONE](https://p3terx.com/archives/scoop-the-best-windows-package-manager.html)

## 前言

在知道并安装Scoop的时候只是稍微听说过`winget-cli`一类的工具，不过由于一直对Windows系统的软件管理早就绝望，下意识的认为对Windows来说，这种终端的程序管理应该几乎没什么用。但在前几天偶然希望在`Windows Terminal`上寻找一个类似`Linux`的`sudo`的程序，发现了Scoop这个神器，并且在使用了一两天尝到甜头后，决定写一篇博客把大概的使用功能都记录一下。

## Scoop的安装

### 前置条件

安装在联网的情况下有直接的指令，但是安装之前需要保证环境满足以下要求：

* Windows 的版本不低于 Windows 7
* Windows 的 PowerShell 版本不低于 PowerShell 3
* 拥有能自由前往Github，保证传输稳定的网络环境
* Windows的用户名为**英文或者数字（非中文）用户名**

### 装前须知

#### 默认安装路径

Scoop默认情况下和Linux中一样，只有普通用户的权限，其中Scoop本身和他默认安装的软件，会安装在`%USERPROFILE\scoop`目录下，使用管理员权限进行全局安装的软件会在`C:\ProgramData\scoop`目录下。

#### 修改路径

1. 打开`PowerShell`

2. 设置用户的安装路径

   ```powershell
   $env:SCOOP='\PathTo\'  ## 这里填需要设置的路径
   [Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
   ```

3. 设置全局安装的路径

   ```powershell
   $env:SCOOP_GLOBAL='\PathToGlobal\'  ## 这里填需要设置的全局安装路径
   [Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
   ```

然后就可以开始愉快的安装了。

### 开始安装

1. 在PowerShell中输入以下内容，来保证本地脚本的执行：

   ```powershell
   set-executionpolicy remotesigned -scope currentuser
   ```

2. 用下面的命令来安装`Scoop`

   ```powershell
   iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
   ```

3. 安装完成，可以通过以下指令来查询帮助

   ```powershell
   scoop help
   ```

## 网络设置

由于网络可能有的时候不稳定，大部分Scoop的软件在安装的时候可能会出现安装失败的情况，就需要我们自己手动进行代理的设置，设置代理的命令如下：

```powershell
scoop config proxy [IP/DNS]:[端口]
```

## 使用手册

### 常用需安装软件

1. aria2

   常用的强力下载工具，设置好`aria2`的`conf`文件并创建`session`文件，配合以下vbs脚本，创建快捷方式以后，在Win+R后运行`Shell:Common Startup`,将快捷方式放于其中，就可以当日用的下载工具了。

   VBScript:

   ```vbscript
   CreateObject("WScript.Shell").Run "aria2c.exe --conf-path=aria2.conf",0
   ```

   在安装完毕aria2后，scoop会默认用aria2来下载所有其他的软件，如果有的时候发现aria2下载不好使了，可以通过下面的指令来禁用aria2下载

   ```powershell
   scoop config aria2-enabled false
   ```

   另外参考`P3TERX`大佬的博客中，其他选项可以按如下设置：

   >单任务最大连接数设置为 `32`，单服务器最大连接数设置为 `16`，最小文件分片大小设置为 `1M`
   >
   >```powershell
   >scoop config aria2-split 32
   >scoop config aria2-max-connection-per-server 16
   >scoop config aria2-min-split-size 1M
   >```

2. sudo

   一个提权工具，可以让Windows下实现和Linux类似的提权效果

3. git

   应该没啥好说的，必备安装。

4. nerd-fonts字体

   在终端美化中常见的一种Powerline字体，使用以下指令添加库然后就能安装

   ```powershell
   scoop bucket add nerd-fonts
   ```

    查询可以用的所有字体

   ```powershell
   scoop search "-NF"
   ```

   因为安装字体需要管理员权限，所以需要添加sudo，指令如下（以Hack NF为例）

   ```powershell
   sudo scoop install Hack-NF
   ```

5. LANDrop 局域网文件分享

   一个很好用的局域网文件共享工具，可以高速在不同系统平台之间分享文件。

### 查阅手册

大部分的使用帮助通过`scoop help`命令都可以直接列出并查看，常见的`search`、`install`、`update`和`uninstall`等指令不多做赘述。这里提供一些常见自己需要查阅的指令，以供日后使用参考。

> #### 清理安装包缓存
>
> Scoop 会保留下载的安装包，对于卸载后又想再安装的情况，不需要重复下载。但长期累积会占用大量的磁盘空间，如果用不到就成了垃圾。这时可以使用 `scoop cache` 命令来清理。
>
> * `scoop cache show` - 显示安装包缓存
> * `scoop cache rm <app>` - 删除指定应用的安装包缓存
> * `scoop cache rm *` - 删除所有的安装包缓存
>
> 如果你不希望安装和更新软件时保留安装包缓存，可以加上 `-k` 或 `--no-cache` 选项来禁用缓存：
>
> * `scoop install -k <app>`
> * `scoop update -k *`
>
> #### 删除旧版本软件
>
> 当软件被更新后 Scoop 还会保留软件的旧版本，更新软件后可以通过 `scoop cleanup` 命令进行删除。
>
> * `scoop cleanup <app>` - 删除指定软件的旧版本
> * `scoop cleanup *` - 删除所有软件的旧版本
>
> 与安装软件一样，删除旧版本软件的同时也可以清理安装包缓存，同样是加上 `-k` 选项。
>
> * `scoop cleanup -k <app>` - 删除指定软件的旧版本并清除安装包缓存
> * `scoop cleanup -k *` - 删除所有软件的旧版本并清除安装包缓存
>
> #### 全局安装
>
> 全局安装就是给系统中的所有用户都安装，且环境变量是系统变量，对于需要设置系统变量的一些软件就需要全局安装，比如 Node.js、Python ，否则某些情况会出现无法找到命令的问题。
>
> 使用 `scoop install <app>` 命令加上 `-g` 或 `--global` 选项可对软件进行全局安装，全局安装需要管理员权限，所以需要提前以管理员权限运行的 Pow­er­Shell 。更简单的方式是先安装 `sudo`，然后用 `sudo` 命令来提权执行：
>
> ```none
> scoop install sudo
> sudo scoop install -g <app>
> ```
>
> > 达成在 Win­dows 上使用`sudo`的成就
>
> 使用 `scoop list` 命令查看已装软件时，全局安装的软件末尾会有 `*global*` 标志。
>
> 此外对于全局软件的更新和卸载等其它操作，都需要加上 `-g` 选项：
>
> * `sudo scoop update -g *` - 更新所有软件（且包含全局软件）
> * `sudo scoop uninstall -g <app>` - 卸载全局软件
> * `sudo scoop uninstall -gp <app>` - 卸载全局软件（并删除配置文件）
> * `sudo scoop cleanup -g *` - 删除所有全局软件的旧版本
> * `sudo scoop cleanup -gk *` - 删除所有全局软件的旧版本（并清除安装包包缓存）
