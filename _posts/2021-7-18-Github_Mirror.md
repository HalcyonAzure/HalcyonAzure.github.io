---
layout: article
title: "Github设置FastGit镜像加速访问"
tag: git
---

# 参考网站

[使用指南 | FastGit UK Document](https://doc.fastgit.org/zh-cn/guide.html#web-的使用)

# 指令

```shell
git config --global url."https://hub.fastgit.org/".insteadOf "https://github.com/"
git config protocol.https.allow always
```

> 仅作为查阅时候的记录使用

