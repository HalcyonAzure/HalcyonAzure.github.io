---
layout: article
title: "程序main函数入口arg参数的用处"
date: 2021-10-29
categories: 知识记录
tags: cpp
---

## 参考文章

* [关于int main( int argc, char* argv[] ) 中arg和argv参数的解析及调试](https://blog.csdn.net/LYJ_viviani/article/details/51873961)

## 前言

今天在看一些代码的时候偶然看到自己刚开始学C的时候，`main()`函数中都会有一个`(int argc,char* argv[],char **env)`的传参。但是到现在依旧不理解这几个参数的意义和它们代表的作用，在稍微查阅了一下以后，浅显的总结一下。

## 具体意义

如果要使用`argc`和`argv`的话（`char **env`暂时没遇到，不做记录），只需要在`main`函数当中添加这两个参数即可，大致参考写法类似如下：

```c++
int main(int argc, char** argv)
{
    ...
    return 0;
}
```

### 解释

`argc`是一个整形的参数，代表了程序运行的时候发送给`main()`函数的参数个数。

`argv`则是一个字符串的数组，用来指向存放对应参数的字符串。

其中，`argv[]`数组中的元素有`argc`个，并且有：

* `argv[0]`包含的是程序运行的路径名字
* `argv[1]`包含的是程序命名后的第一个字符串
* `argv[2]`包含的是程序命名后的第二个字符串
* ....
* `argv[argc]`为NULL

## 演示方法

为让以上解释更加形象，这里引入示例代码进行解释：

```cpp
#include<iostream>
using namespace std;

int main(int argc, char* argv[])
{
    for(int i = 0; i < argc; i++)
    {
        cout<<"Argument"<<i<<" is "<<argv[i]<<endl;
    }
    return 0;
}
```

假设代码文件存放于`./b.cpp`文件当中，通过编译器编译后的可执行文件为`b`。在执行如下指令：

```shell
./b
```

返回的内容为：

```shell
Argument0 is ./b
```

在执行如下指令：

```shell
./b oneString twoString threeString
```

返回的内容为：

```shell
Argument0 is ./b
Argument1 is oneString
Argument2 is twoString
Argument3 is threeString
```

对应了上文中的`argc`的元素个数和`argv`的字符串内容，即`./b`后面的`oneString`、`twoString`和`threeString`。
