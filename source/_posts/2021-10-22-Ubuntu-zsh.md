---
layout: article
title: "Oh My Zsh安装手册"
tag: Linux
---

## 参考文章

* [Ubuntu 下 Oh My Zsh 的最佳实践「安装及配置」 - SegmentFault 思否](https://segmentfault.com/a/1190000015283092)
* [用 zsh-proxy 一键配置常用代理](https://www.mokeyjay.com/archives/2685)

## 安装Oh My Zsh

### 安装Zsh

```shell
sudo apt install zsh -y
chsh -s /bin/zsh
echo $SHELL  ## 如果输出bash则需要重启SHELL
```

### 脚本安装

```shell
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```

## Zsh的配置

### 字体

字体安装（Hack NF）

```shell
apt install fonts-hack
```

其他字体：[ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)

### 主题切换

1. 编辑zsh配置文件

   ```shell
   vim ~/.zshrc
   ```

2. 修改主题（以agnoster为例）

   将`ZSH_THEME="xxx"`改为`ZSH_THEME="agnoster"`

### 插件配置

1. 安装`zsh-autosuggestions`、`zsh-syntax-highlighting`、`zsh-proxy`和`autojump`

   ```shell
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   git clone https://github.com/sukkaw/zsh-proxy.git ~/.oh-my-zsh/custom/plugins/zsh-proxy
   sudo apt install autojump
   ```

2. 配置插件，编辑`.zshrc`文件，在`plugins`处添加，类似效果如下：

   ```shell
   ## 根据官方文档，zsh-syntax-highlighting 插件需放在最后
   plugins=(
     git extract autojump zsh-autosuggestions zsh-proxy zsh-syntax-highlighting 
   )
   ```

3. `zshrc`完整文件配置帮助

   ```shell
   ## 以下内容去掉注释即可生效：
   ## 启动错误命令自动更正
   ENABLE_CORRECTION="true"
   
   ## 在命令执行的过程中，使用小红点进行提示
   COMPLETION_WAITING_DOTS="true"
   ```
