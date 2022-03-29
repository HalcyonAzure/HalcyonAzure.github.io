---
layout: article
title: "文件权限"
tag: Linux
---

参考文章

1.[Ubuntu群组管理](https://segmentfault.com/a/1190000024532631)

## Linux用户和群组

​        Linux下拥有着不同的用户和群组，群组可以是一个用户的集群，通过修改Linux的用户和对应的群的权限可以较为安全的对文件进行操作。

## 群组管理

***接下来所有的内容都是基于`Ubuntu 20.04 LTS`***

### 新增群组

在我们需要对多个用户进行相同的权限管理的时候，可以通过创建对应群组来进行管理，这里以`demog`为例

```shell
addgroup demog
```

#### 用户和组的关系

##### 修改用户账户

以`demo`用户为例，在有`root`权限的情况下输入以下指令来设置`demo`的初始组为`demog`

```shell
usermod -g demog demo
```

**首先是`组`然后才是`用户`**

##### 查看用户当前的组

要查询当前用户所在的组信息，可以使用类似如下指令

```shell
groups demo
```

如果要把一个用户添加到多个群组可以用如下指令（先去除后添加，请勿直接尝试指令）

```shell
groups -G demog1 demog2 demog3 demo
```

> 配合`-g`或者`-G`参数的时候，会把用户从原本的组里面剔除，然后加入到新的组里面，如果需要的是`-a`的参数，表示的是“追加”

#### 删除群组

指令很简单，如下格式

```shell
delgroup demog
```
