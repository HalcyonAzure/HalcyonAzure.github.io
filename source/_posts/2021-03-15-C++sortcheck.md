---
layout: article
title: "sort内函数调用"
tag: cpp
---

## 代码

```c++
#include<bits/stdc++.h>//万能头
using namespace std;
int q[1000];
bool cmp(int b,int s)//比较函数，big>small,输出从大到小
{
    return b>s;
}
int main()
{
    int input;
    cin>>input;
    for(int i = 0;i<input;i++)
    {
        cin>>q[i];
    }
    sort(q,q+input,cmp);
    for(int i = 0;i<input;i++)
    {
        cout<<q[i]<<" ";
    }
    return 0;
}
```

## 备注

1. sort函数的载入格式为

   `sort(array.begin(),array.end(),function);`

   在begin输入起始位置，在end输入结束位置，function输入要对比的函数即可。

2. 函数里面包含两个参数，按大于小于号返回比较大/比较小的那个，成员函数同样适用，并且sort函数在使用函数进行排序的速度可以达到和快排差不多的效果。
