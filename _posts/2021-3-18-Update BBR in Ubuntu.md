---
layout: article
title: "通过一键式脚本来安装魔改/优化BBR"
date: 2021-3-18
descripiton: "解决Ubuntu本身系统TCP传输效率较低，速度跑不满的问题"
tag: Ubuntu
---

本文脚本来源：[Linux-NetSpeed-github](https://github.com/ylx2016/Linux-NetSpeed)

本文参考博客：[地址](https://v2xtls.org/linux%e4%b8%80%e9%94%ae%e5%ae%89%e8%a3%85%e5%b8%b8%e8%a7%81-%e6%9c%80%e6%96%b0%e5%86%85%e6%a0%b8%e8%84%9a%e6%9c%ac-%e9%94%90%e9%80%9f-bbrplus-bbr2-1-3-2-53/)

1. 安装依赖库(Ubuntu下，CentOS请在github脚本来源查询)

   ```shell
   apt-get install ca-certificates wget -y && update-ca-certificates
   ```

2. 安装脚本

   ```shell
   wget -N --no-check-certificate "https://github.000060000.xyz/tcpx.sh" && chmod +x tcpx.sh && ./tcpx.sh
   ```
   
3. 在Ubuntu19以下的系统可以用BBRplus，其他不明，自用为原版BBR加速和系统设置加速。

4. 设置完毕以后通过speedtest-cli测速，明显传输快了很多。

