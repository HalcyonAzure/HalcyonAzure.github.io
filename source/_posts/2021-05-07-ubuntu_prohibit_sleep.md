---
layout: article
title: "Ubuntu通过systemd禁用系统睡眠"
date: 2021-05-07
categories: 小技巧
tags: Linux
---

## 参考网址

1. [How To: Disable Sleep on Ubuntu Server (unixtutorial.org)](https://www.unixtutorial.org/disable-sleep-on-ubuntu-server/)

## 查看系统休眠的记录

```shell
sudo systemctl status sleep.target
```

> 理论上会返回类似如下的内容，里面会注明系统休眠的时间等信息
>
> ```shell
> root@azhal:~## systemctl status sleep.target
> ● sleep.target - Sleep
>      Loaded: loaded (/lib/systemd/system/sleep.target; static; vendor preset: enabled)
>      Active: inactive (dead)
>        Docs: man:systemd.special(7)
> 
> May 07 18:54:58 azhal systemd[1]: Reached target Sleep.
> May 07 20:19:14 azhal systemd[1]: Stopped target Sleep.
> May 07 20:39:14 azhal systemd[1]: Reached target Sleep.
> May 07 20:52:35 azhal systemd[1]: Stopped target Sleep.
> ```

## 关闭系统休眠

```shell
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

> [引用文章原话] This is obviously a very simple way of disabling power management, but I like it because it’s standard and logical enough – there’s no need to edit config files or create cronjobs manually controlling sleep functionality.
>
> 大概翻译过来就是指这样的操作标准且合理，因为这样省去了编辑任何文件的麻烦，并且也达到了禁用休眠的目的。
>
> 禁用以后大致会变成这样：
>
> ```shell
> root@azhal:~## systemctl status sleep.target
> ● sleep.target
>      Loaded: masked (Reason: Unit sleep.target is masked.)
>      Active: inactive (dead)
> 
> May 07 18:54:58 azhal systemd[1]: Reached target Sleep.
> May 07 20:19:14 azhal systemd[1]: Stopped target Sleep.
> May 07 20:39:14 azhal systemd[1]: Reached target Sleep.
> May 07 20:52:35 azhal systemd[1]: Stopped target Sleep.
> ```

## 恢复系统休眠服务器

```shell
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
