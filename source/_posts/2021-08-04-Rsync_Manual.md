---
layout: article
title: "Rsync手册"
tag: Linux
---

## 参考文章

1. [rsync 用法教程](https://www.ruanyifeng.com/blog/2020/08/rsync.html)
2. [RSYNC备份服务](https://www.jianshu.com/p/b0157e4ab801)

## Rsync介绍

​    Remote-Sync，意味远程动态同步，可以在不同的主机之间进行同步操作，相比一般将文件一次性全部备份而不同的好处是，Rsync可以做到每次增量同步，只对部分文件进行修改，目前个人主要用来和`WebDAV`挂载的本地目录进行配合使用，对服务器进行备份处理

## 常见用法

### 本地使用

* 增量同步

    ```shell
    rsync -avz [SRC] [DEST]
    ## [SRC]为源目录
    ## [DEST]为目标目录
    ## -a：优于-r的递归参数，会同步文件的元信息（时间和权限等，在增量更新中有重要作用）
    ## -v：将结果或过程打印在控制台内
    ## -z 同步时压缩数据
    ```

* 镜像同步

  ```shell
  rsync -avz --delete [SRC] [DEST]
  ## --delete：当检测到源文件中某个文件被删除的同时，将删除操作也同样进行同步，变成目标镜像
  ```

* 排除文件

  > 这里以排除掉所有带`.log`字样的文件为例

  ```shell
  rsync -avz --delete --exclude '*.log' [SRC] [DEST]
  ## --exclude为字符过滤，其中这个过滤也包括了隐藏文件
  ```

  当有多个排除模式的时候，可以使用多个`--exclude`参数，也可以使用`Bash`的大括号

  ```shell
  ## 使用多个--exclude参数
  rsync -avz --delete --exclude '*.log' '*.txt' [SRC] [DEST]
  ## 使用Bash
  rsync -avz --delete --exclude={'*.log','*.txt'} [SRC] [DEST]
  ```

  排除隐藏文件，以及排除目录中所有文件的同时保存目录本身

  ```shell
  ## 排除隐藏文件，在Linux中即类似`.ssh`一类以'.'开头的文件，这个时候忽略'.*'即可
  rsync -avz --delete --exclude '.*' [SRC] [DEST]
  
  ## 排除目录中所有文件的同时保存目录本身
  rsync -avz --delete --exclude 'dir/*' [SRC] [DEST]
  ## 可以做到保存dir目录的同时，不保存dir下的所有文件
  ```

  排除的同时又强制锁定

  > 如果需要排除所有"*.log"的同时，又希望保存所有demo.log的文件，则可以配合`--include`参数一起使用，以下为例子

  ```shell
  rsync -avz --delete --include="demo.log" --exclude="*.log" [SRC] [DEST]
  ```

### 远程使用

TODO

## 基准目录备份

TODO
