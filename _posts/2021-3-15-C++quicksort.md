---
layout: article
title: "C++实现快速排序"
date: 2021-3-15
description: "C++中快速排序实现的代码"
tag: Cpp_Algorithm
---

# 代码模板

```
void qsort(int l, int r, int q[])
{
    if (l >= r)
        return;
    int i = l - 1, j = r + 1, x = q[(l + r)>>1];
    while (i < j)
    {
        do
            i++;
        while (q[i] < x);
        do
            j--;
        while (q[j] > x);
        if (i < j)
            swap(q[i], q[j]);
    }
    qsort(l, j, q);
    qsort(j + 1, r, q);
}
```

# 代码原理

## 扫描

​	函数需要读入三个数值，一个是通过指针引入数组`q[]`，另外两个分别是数组的左端点和右端点，在这里设置为`l`和`r`在代码中随机取一个位置`e.g. x= q[l+r>>1]`，作为分界点`x=q[]`，然后使用两个指针，一个从前向后扫描数组，一个从后向前扫描数组。其中命名从前向后扫描数组的指针为`i`，而从后向前扫描数组的指针叫为`j`，然后开始扫描。

​	在扫描过程中，在这里以从小到大排序为例，因为小的数字需要排列在前面，所以在`i`从前向后扫描的时候，如果遇到了比`q[x]`更大的数字则停止继续扫描，这个时候让`j`从后向前开始扫描，如果遇到了比`q[x]`更小的数字则停止扫描。

​	**Tips:由于`--j`比`++i`要后运行，实际情况下常常为`j`穿过`i`，而`i`的位置往往不一定是分界位置，所以尽量取`j`作为分界位置 **

## 交换

​	由于最后输出的需要是小的数字在前面，而大的数字在后面，所以在扫描都停止以后，将`j`指向的小数字和`i`指向的大数字相互交换位置，就可以把他们正确的放于左边小于`q[i]`，右边大于`q[i]`，然后再一直进行扫描，直到`i`和`j`重合或者穿过的时候停止扫描，然后再通过递归的方式进行多次分段扫描，直到所有的函数都不能再进行交换(`if(l>=r) return;`)就返回最后的数值。

​	Ps：在一次扫描+交换结束以后，`i`左边的所有数字一定小于`x`，而`j`右边的数字一定大于`x`

# 时间复杂度

O(n*logn)

## 注意

1. 取x的时候如果用位运算，只需要>>1即可，不要移动多了，不然会出现越界或者其他特殊情况（记住模板就好）
2. 在分治的qsort中（`e.g. qosrt(l,j,q)`）如果取`j`则在上方取`x=q[？]`中绝对不能取`x=q[r]`的情况，不然会出现由于边界问题导致的死循环。快捷记忆的方法为：**如果x取了右端点，则分治不为右。如果x取了左端点，则分治不为左**

