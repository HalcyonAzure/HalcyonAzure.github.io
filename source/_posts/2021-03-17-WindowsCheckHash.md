---
layout: article
title: "Windows计算文件Hash"
tag: Windows
---

​    每次要查询一个文件的hash值的时候总要打开一个hash校验工具，觉得有些麻烦了，加上也不是所有文件都会经常需要校验，就常常并不想单独下载一个工具，查询到Windows有自带的hash校验指令，于是记录一下，以下内容摘自[知乎](https://zhuanlan.zhihu.com/p/344545687)

1. 使用certutil

   > Windows从Win7开始，包含了一个CertUtil命令，可以通过这个命令来计算指定文件的杂凑值(Hash Value)

   使用的指令为:

   `certutil -hashfile [fileName] [algorithm]`

   其中`[algorithm]`指不同的hash算法，可以取的值有：**MD2、MD4、MD5、SHA1、SHA256、SHA384、SHA512**。

   例子:

   `certutil -hashfile D:\test.txt MD5`

2. 使用Get-FileHash

   `Get-FileHash [fileName] -Algorithm [algorithm]`

   其中，支持的算法有**MACTripleDES、MD5、RIPEMD160、SHA1、SHA256、SHA384、SHA512**。

   显示效果:

   ![Hash_1](/2021/03/images/HashCheck_1.png)

   其中，为了方便观察可以通过管道使用Format-List

   `Get-FileHash .\test.txt -Algorithm SHA512 | Format-List`

   显示效果:

   ![Hash_2](/2021/03/images/HashCheck_2.png)
