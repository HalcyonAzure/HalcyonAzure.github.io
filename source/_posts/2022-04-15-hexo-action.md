---
layout: article
title: "使用Github Actions自动部署Hexo"
date: 2022-04-15 14:00:00
categories: 小技巧
tags: hexo
---

## 前言

之前博客一直用的都是`Jekyll`框架，在使用`Github Pages`进行部署的时候并不需要自己手动配置，不过在换了`Hexo`主题之后，每次写完了博客除了要`push`一次`commit`到博客的内容分支上，还需要自己手动`deploy`一次。虽然也不会很麻烦，不过用`Github Actions`来完成这个过程也要更顺畅一些。原本觉得这个需求应该很简单，直接在`Actions`上执行一次`hexo g -d`的指令就好，结果因为`Github`在`HTTPS`上对`Token`的验证，以及`Hexo`自带的`one-command-deployment`存在[BUG](https://github.com/hexojs/hexo/issues/4757#issuecomment-901613964)，折腾到凌晨两三点才发现，并且通过`issues`里面提供的修改链接使用`oauth`进行`url`验证的方法还是失败了，最后花了半小时改成了`ssh`密钥验证很轻松就完成了。。下面为对`Hexo`的`Actions`的脚本的一个备份

## 脚本备份

配置文件

```yaml
name: Hexo Deploy

on:
  push:
    branches:
      - hexo

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          ref: hexo

    # Caching dependencies to speed up workflows. (GitHub will remove any cache entries that have not been accessed in over 7 days.)
      - name: Cache node modules
        uses: actions/cache@v1
        id: cache
        with:
          path: node_modules
          key: ${{ runner.os }}-node-v2-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-v2

      - name: Install Dependencies
        if: steps.cache.outputs.cache-hit != 'true'
        run: |
          npm ci

      # Deploy hexo blog website.
      - name: Build and Deploy
        run: |
          mkdir -p ~/.ssh/
          echo "${{ secrets.DEPLOY_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts
          git config --global user.email "halc-days@outlook.com"
          git config --global user.name "HalcyonAzure"
          npx hexo g -d
          rm -rf ~/.ssh/id_rsa
```

整个脚本大致流程为

1. 检测到`hexo`的内容分支有`push`之后，`checkout`到内容分支。

2. 判断是否有`nodejs`的`modules`缓存。
   * 如果检测到有效缓存则跳过安装步骤，直接进行下一步。
   * 如果没有检测到有效缓存则对模块进行部署

3. 创建`id_rsa`密钥文件，并将仓库中`DEPLOY_KEY`的`secret`写入密钥文件，并且配置`github.com`的信任和全局帐号邮箱

4. 对`hexo`进行`generate & deploy`操作

5. 删除写入的密钥文件
