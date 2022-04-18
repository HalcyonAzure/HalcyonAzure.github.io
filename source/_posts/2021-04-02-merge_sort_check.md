---
layout: post
title: "逆序对"
date: 2021-04-02 10:00:00
categories: 知识记录
tags: 算法
---

## 代码模板

```cpp
typedef long long LL
LL merge(int l,int r)
{
    if(l==r) return 0;
    int mid=l+r>>1;
    LL ans = merge(l,mid)+merge(mid+1,r);
    
    int i=l,j=mid+1,cnt=0;
    while(i<=mid&&j<=r)
    {
        if(q[i]<=q[j]) tmp[cnt++]=q[i++];
        else
        {
            tmp[cnt++]=q[j++];
            ans+=mid-i+1;
        }
    }//统计
    //扫尾
    while(i<=mid) tmp[cnt++]=q[i++];
    while(j<=r) tmp[cnt++]=q[j++];
    //扫描完毕
    for(i=l,j=0;i<=r;i++,j++) q[i]=tmp[j];
    return ans;
}
```

## 代码原理

### 归并排序

​    逆序需要的是判断前面数字比后面大的时候组成一个`逆序对`，而为了扫描的过程中只扫描一部分，不全部扫描即可得出答案，达到优化的目的，这里采用归并排序的思路，在分为A和B两组数组的同时，如果判断到了A中有一个数字比B中另外一个数字大的话，就可以很肯定的判断A之后的数字和该小的B数字都可以组成逆序对，因此可以达到简化运算量的效果。

## 注意

1. 对于结束的情况返回`return 0`
2. **由于分治的过程中十分有可能出现代码规模超过`int`的情况，所以这里会使用`long long`进行数据的定义。**
3. 由于等于的情况并不算逆序对，所以在判断`if`的时候要把等于号带上
4. 通过先对最原始的”大片段“进行计算逆序对的数量，然后逐渐细化扫描更小的逆序对的数量，在扫描到return之后加起来返回的就是整个数列全部情况的逆序对的总数了。
