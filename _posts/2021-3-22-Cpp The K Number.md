---
layout: article
title: "C++快速选择第K个数字"
date: 2021-3-22
description: "C++快速排序选择算法"
tag: Cpp_Algorithm
---

# 代码模板

```c++
int qchoise(int q[], int l, int r, int pos)
{
    if (l == r)
        return q[l];
    int i = l - 1, j = r + 1, x = q[(l + r) / 2];
    while (i < j)
    {
        while (q[++i] < x)
        {
        }
        while (q[--j] > x)
        {
        }
        if (i < j)
            swap(q[i], q[j]);
    }
    int sl = j - l + 1;
    if (pos <= sl)
        return qchoise(q, l, j, pos);
    return qchoise(q, j + 1, r, pos - sl);
}
```

# 代码原理

## 扫描+交换

第一步首先和之前的快速排序算法相同，首先在第一步的时候随机取一个位置，然后将这个位置的数字`q[x]`记录下来，然后一个指针`i`从前向后扫描数列，一个指针`j`从后向前扫描数列，最后一般来说最后`i`会在`x`的位置停下，而`j`会停在x的前一个。这样第一轮的排序就达成了，在`q[x]`前面的数字都比`q[x]`小，在`q[x]`后面的数字都比它大。

## 位置排序

将整个数列分为`Left`和`Right`两部分，统计`Left`和`Right`的数量，如果`pos`<`Left的数量`，则说明需要的数字在`Left`序列里面，这个时候只需要再次对`Left`序列进行递归，如果数字在`Right`序列中，则说明`pos`的位置变成了第`pos-[Left的数量]`个，然后只需要对右半边进行递归即可

## 结果

在不断进行递归操作后，将会只剩下`pos`位置的数字，也就是第`pos`个数字，这个时候返回的结果就是第`pos`个数字了。

## 时间复杂度

第一次扫描的时候时间复杂度为n，第二次扫描的时候由于是扫描一半，所以最多也只有1/2n，然后依次下去就是1/4n，1/8n.....，由数学知识可以得出，n+1/2n+... 最多不会超过2n，所以复杂度为`O(n)`。